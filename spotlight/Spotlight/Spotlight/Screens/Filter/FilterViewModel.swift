//
//  FilterViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.03.2022.
//

import Foundation
import Combine

class FilterViewModel {
    
    enum FilterSection: Int, CaseIterable {
        case sort
        case language
        case button
    }
    
    // MARK: - Private properties
    private var selectedSortCategory: Sorter?
    private var selectedLanguageCategory: Language?
    
    // MARK: - Public properties
    var currentSortCategory: Sorter? {
        return selectedSortCategory
    }
    
    var currentLanguageCategory: Language? {
        return selectedLanguageCategory
    }
    
    // MARK: - Public API
    func changeSort(category: Sorter?) {
        selectedSortCategory = category
    }
    
    func changeLanguage(category: Language?) {
        selectedLanguageCategory = category
    }
    
    func reset() {
        selectedSortCategory = nil
        selectedLanguageCategory = nil
    }
    
    func toggleCategory(at indexPath: IndexPath) {
        guard let sectionType = FilterSection(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .sort:
            let category = sortCategory(at: indexPath.item)
            if category == selectedSortCategory {
                selectedSortCategory = nil
            } else {
                selectedSortCategory = category
            }
        case .language:
            let category = languageCategory(at: indexPath.item)
            if category == selectedLanguageCategory {
                selectedLanguageCategory = nil
            } else {
                selectedLanguageCategory = category
            }
        default:
            break
        }
    }
}

// MARK: - Collection View Logic
extension FilterViewModel {
    
    var numberOfSections: Int {
        FilterSection.allCases.count
    }
    
    func section(of index: Int) -> FilterSection? {
        FilterSection(rawValue: index)
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = FilterSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .sort:
            return Sorter.allCases.count
        case .language:
            return Language.allCases.count
        case .button:
            return 1
        }
    }
    
    func sortCategory(at index: Int) -> Sorter? {
        guard index < Sorter.allCases.count else { return nil }
        return Sorter.allCases[index]
    }
    
    func languageCategory(at index: Int) -> Language? {
        guard index < Language.allCases.count else { return nil }
        return Language.allCases[index]
    }
    
    // MARK: - Data
    func headerTitle(in section: Int) -> String {
        guard let sectionType = FilterSection(rawValue: section) else { return "" }
        switch sectionType {
        case .sort:
            return L10n.sort
        case .language:
            return  L10n.language
        case .button:
            return ""
        }
    }
    
    func itemName(for sectionType: FilterSection, at index: Int) -> String {
        switch sectionType {
        case .sort:
            return Sorter.allCases[index].rawValue.firstUppercased
        case .language:
            return Language.allCases[index].rawValue
        case .button:
            return ""
        }
    }
    
    func isItemSelected(at indexPath: IndexPath) -> Bool {
        guard let sectionType = FilterSection(rawValue: indexPath.section) else { return false }
        switch sectionType {
        case .sort:
            return selectedSortCategory == Sorter.allCases[indexPath.item]
        case .language:
            return selectedLanguageCategory == Language.allCases[indexPath.item]
        default:
            return false
        }
    }
}
