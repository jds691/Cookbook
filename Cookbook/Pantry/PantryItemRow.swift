//
//  PantryItemRow.swift
//  Cookbook
//
//  Created by Neo on 25/09/2023.
//

import SwiftUI
import CookbookKit

struct PantryItemRow: View {
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("showExactDates") private var showExactDates: Bool = false
    
    @State private var showEditSheet: Bool = false
    @State private var showConfirmItemDeletion: Bool = false
    
    var item: PantryItem
    let relativeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        
        return formatter
    }()
    let calendar = Calendar.current
    
    init(item: PantryItem) {
        self.item = item
    }
    
    var body: some View {
        TimelineView(.everyMinute) { context in
            HStack {
                Image(systemName: statusIconName)
                    .imageScale(.large)
                    .foregroundStyle(statusColor)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(status)
                        .foregroundStyle(statusColor)
                }
            }
            .onAppear {
                handleItemUpdate(context)
            }
        }
        .onTapGesture {
            showEditSheet = true
        }
        .contextMenu(menuItems: {
            quickActions
            Button(role: .destructive) {
                showConfirmItemDeletion = true
            } label: {
                Label("ACTION_DELETE", systemImage: "trash")
            }
        })
        .swipeActions {
            /*Button(role: .destructive) {
             showConfirmItemDeletion = true
             } label: {
             Label("Delete", systemImage: "trash")
             }*/
            quickActions
        }
        .confirmationDialog(noticeContentDeleteItem, isPresented: $showConfirmItemDeletion, titleVisibility: .visible) {
            Button(role: .destructive) {
                item.removeAllNotifications()
                withAnimation {
                    modelContext.delete(item)
                }
            } label: {
                Text("ACTION_DELETE")
            }
        }
        .sheet(isPresented: $showEditSheet) {
            PantryEditItemView(item: item)
        }
    }
    
    // Every time the view is refreshed from TimelineView, it will update the state of the item as well
    private func handleItemUpdate(_ context: TimelineViewDefaultContext) {
        if item.expiryDate.withoutTime <= context.date.withoutTime && (item.state == .opened || item.state == .sealed) {
            item.state = .expired
        }
    }
    
    private var status: String {
        switch item.state {
        case .sealed, .opened:
            if showExactDates {
                return "Expires \(item.expiryDate.formatted(date: .numeric, time: .omitted))"
            } else {
                let relativeText: String = relativeFormatter.localizedString(for: item.expiryDate, relativeTo: .now.withoutTime)
                
                return "Expires \(relativeText)."
            }
            
            
        case .frozen:
            if showExactDates {
                return "Frozen on \(item.inStateSince.formatted(date: .numeric, time: .omitted))"
            } else {
                let relativeText: String = relativeFormatter.localizedString(for: item.inStateSince.withoutTime, relativeTo: .now.withoutTime)
                
                return "Frozen \(relativeText)."
            }
            
        case .expired:
            if showExactDates {
                return "Expired on \(item.expiryDate.formatted(date: .numeric, time: .omitted))"
            } else {
                let relativeText: String = relativeFormatter.localizedString(for: item.expiryDate.withoutTime, relativeTo: .now)
                
                return "Expired \(relativeText)."
            }
        }
    }
    
    @ViewBuilder
    private var quickActions: some View {
        switch item.state {
        case .sealed:
            Button {
                item.open()
            } label: {
                Label(actionMarkOpened, systemImage: "clock")
            }
            .tint(.orange)
            Button {
                item.freeze()
            } label: {
                Label(actionMarkFrozen, systemImage: "snowflake")
            }
            .tint(.teal)
        case .opened:
            Button {
                item.freeze()
            } label: {
                Label(actionMarkFrozen, systemImage: "snowflake")
            }
            .tint(.teal)
        case .frozen:
            Button {
                item.open()
            } label: {
                Label(actionUnfreeze, systemImage: "clock")
            }
            .tint(.orange)
        case .expired:
            EmptyView()
        }
    }
    
    private var statusColor: Color {
        switch item.state {
        case .sealed, .opened:
            if item.isExpiringSoon {
                return .orange
            } else {
                return .green
                
            }
        case .frozen:
                return .teal
        case .expired:
                return .red
        }
    }
    
    private var statusIconName: String {
        switch item.state {
        case .sealed, .opened:
            if item.isExpiringSoon {
                return "exclamationmark.circle"
            } else {
                return "checkmark"
                
            }
        case .frozen:
            return "snowflake"
        case .expired:
            return "xmark"
        }
    }
    
    private func stateDateToDays() -> Int {
        let fromDate = calendar.startOfDay(for: item.inStateSince)
        let toDate = calendar.startOfDay(for: .now.withoutTime)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}

extension PantryItemRow {
    var actionMarkOpened: String {
        .init(
            localized: "ACTION_MARK_OPENED",
            defaultValue: "Mark as Opened",
            table: "Pantry"
        )
    }
    
    var actionMarkFrozen: String {
        .init(
            localized: "ACTION_MARK_FROZEN",
            defaultValue: "Mark as Frozen",
            table: "Pantry"
        )
    }
    
    var actionUnfreeze: String {
        .init(
            localized: "ACTION_UNFREEZE",
            defaultValue: "Unfreeze",
            table: "Pantry"
        )
    }
    
    var noticeContentDeleteItem: String {
        .init(
            localized: "NOTICE_CONTENT_DELETE_ITEM",
            defaultValue: "Are you sure you want to delete this item?",
            table: "Pantry"
        )
    }
}

#Preview("Sealed") {
    List {
        PantryItemRow(item: .sealedPreview)
    }
    .previewEmptyContainer()
}

#Preview("Opened") {
    List {
        PantryItemRow(item: .openedPreview)
    }
    .previewEmptyContainer()
}

#Preview("Frozen") {
    List {
        PantryItemRow(item: .frozenPreview)
    }
    .previewEmptyContainer()
}

#Preview("Expired") {
    List {
        PantryItemRow(item: .expiredPreview)
    }
    .previewEmptyContainer()
}
