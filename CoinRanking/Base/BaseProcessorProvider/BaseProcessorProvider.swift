//
//  BaseProcessorProvider.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// An abstract protocol that can be inherited by all processors.
///
/// `BaseProcessorProvider` defines the blueprint for a data processor that transforms raw input data into a processed output.
/// It provides the structure for any class that will handle domain-specific transformations, such as decoding JSON
/// into model objects or processing raw data into meaningful business entities.
///
/// - Associated Types:
///   - `InputData`: The raw input data that needs to be processed. This can be any type of data, such as raw JSON, strings, or other formats.
///   - `ProcessedData`: The type of the processed data that is returned after processing. This is typically a domain-specific model.
protocol BaseProcessorProvider {
	associatedtype InputData
	associatedtype ProcessedData

	/// Processes raw input data and returns a processed output.
	///
	/// - Parameter data: The raw input data that needs to be processed (e.g., raw JSON, strings).
	/// - Returns: A processed output, typically a domain-specific model that results from transforming the input data.
	/// - Throws: An error if the processing of the data fails (e.g., due to invalid data or decoding issues).
	func processData(_ data: InputData) throws -> ProcessedData
}

/// A base class that implements `BaseProcessorProvider` and provides an abstract base for all processors.
///
/// This class is intended to be subclassed. The `processData` method must be overridden in child classes to provide the actual
/// logic for processing the raw input data (e.g., decoding JSON or converting raw data into a domain-specific model).
/// The base class provides a structure for processors, while leaving the implementation of data transformation to subclasses.
///
/// - Generic Parameters:
///   - `InputData`: The raw input data type that needs to be processed.
///   - `ProcessedData`: The transformed output data type that is returned after processing.
class BaseProcessor<InputData, ProcessedData>: BaseProcessorProvider {

	/// Processes raw input data and returns a processed output.
	///
	/// This method is abstract and must be overridden by child classes to implement the actual data processing logic.
	/// In the base class, it raises a `fatalError` to enforce that subclass implementations must provide this logic.
	///
	/// - Parameter data: The raw input data that needs to be processed.
	/// - Throws: This method must be overridden by subclasses to throw relevant errors when data processing fails.
	/// - Returns: The processed data, as defined by the subclass' logic.
	func processData(_ data: InputData) throws -> ProcessedData {
		fatalError("Must be overridden by subclass")
	}
}
