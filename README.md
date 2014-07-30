# AboutYouShop-iOS-SDK

AboutYouShop-iOS-SDK is a library for [AboutYou](http://aboutyou.de) Shop integration in iOS. It is written in Objective-C and requires ARC and the iOS SDK 6.0 or above. The networking- and object mapping engine is build on top of [RestKit](https://github.com/RestKit/RestKit). It provides all necessary functions and convenience methods to make your app fully capable of the About You API.

## Getting Started

- [Register for an account](https://devcenter.mary-paul.de) at the AboutYou Devcenter and create a new app. You will be given credentials to utilize the About You API.
- We strongly recommend using [CocoaPods](http://cocoapods.org) to install the AboutYouShop-iOS-SDK in your iOS project.
- Run and discover the 'ShopExample' project to become familiar with the basic principles of the AboutYouShop-iOS-SDK.
- Need some help? Feel free to ask questions to marius.schmeding(at)slice-dice.de

## Overview

# SDShopManager

You obtain the *SDShopManager* singleton by:

	[SDShopManager sharedManager]

Get friends with it! It will handle several things for you:

- Networking
- Object Mapping
- Session Handling
- User Authentication (OAuth2)

# SDQuery

Object Retrieval and Modification is handled by *SDQuery*. To perform an API operation on an Object, simply call the query constructor, like

	SDQuery *query = [SDProduct queryForSearch];

and use the given methods to modify the query according to your needs

	[query addFields:@[@"variants"]]

Executing the query:

	[query  performInBackground:^(SDResult *result, NSError *error) {

		if (error){
			//check your errors
		}

		if (result){
			//everything you need is in the *SDResult*
		}
	}];


## Setting the App Credentials

	[[SDShopManager sharedManager] setAppId:@"<APP_ID>" andAppPassword:@"<APP_PW>"];

## Retrieving the Category Tree

	SDQuery *categoryQuery = [SDCategory query];
	[categoryQuery performInBackground:^(SDResult *result, NSError *error) {

		if (error){
			//check your errors
		}

		if (result.categoryTree){
        		//you got *SDCategory* objects to work with
        	}

	}];

## Retrieving and Caching Facets 

Say, you want to retrieve all facets from the groups *Color* and *Brand*. The results should be cached.

	NSArray *facetGroups = @[
                             	 @(kSDFacetGroupColor),
                             	 @(kSDFacetGroupBrand)
                             	];

	SDQuery *facetQuery = [SDFacet query];
	[facetQuery addFacetGroupIds:facetGroups];
	[facetQuery performInBackground:^(SDResult *result, NSError *error) {
        
		if (error){
			//check your errors
		}

        	if (result.facets){
            		// you got *SDFacet* objects to work with

			// optionally cache facets for fast access
            		[SDFacet cacheFacets:result.facets];
        	}       
	}];

Later, you can retrieve facets from cache, e.g. all that belong to the group *Color*.

	NSSet *cachedColorFacets = [SDFacet cachedFacetsForGroupId:kSDFacetGroupColor];

## Retrieving Products by IDs

Say, you want 3 products, including all variants.

	NSArray *productIds = @[
				@12345,
				@23456,
				@34567
				];
	
	NSArray *fields = @[@"variants"];

	SDQuery *productQuery = [SDProduct queryForGet];
	[productQuery addProductIds:productIds];
	[productQuery addFields:fields];

	[productQuery performInBackground:^(SDResult *result, NSError *error) {
        
		if (error){
			//check your errors
		}

		if (result.products){
			//you got *SDProduct* objects to work with
		}
	}];

## Using the Basket

Retrieving the Basket.

	SDQuery *basketQuery = [SDBasket query];
	[basketQuery performInBackground:^(SDResult *result, NSError *error) {
        
		if (error){
			//check your errors
		}

		if (result.basket){
			//you got the *SDBasket* object to work with
		}
        
	}];

Adding an Item to the Basket.

	NSNumber *variantId = @12345 // The id of the *SDProductVariant* object to be added

	SDQuery *basketQuery = [SDBasket query];
        [basketQuery addOrderLineForVariantId:variantId];
    
    	[basketQuery performInBackground:^(SDResult *result, NSError *error) {
        
		if (error){
			//check your errors
		}

		if (result.basket){
			//you got the *SDBasket* object to work with
		}
        
	}];

Removing an Item from the Basket.

	NSNumber *itemId = @12345 // The itemId that should be removed

	SDQuery *basketQuery = [SDBasket query];
        [basketQuery removeOrderLineForItemId:itemId];
    
    	[basketQuery performInBackground:^(SDResult *result, NSError *error) {
        
		if (error){
			//check your errors
		}

		if (result.basket){
			//you got the *SDBasket* object to work with
		}
        
	}];

Please note that one orderline adds/removes one Item only.
When constructing a Basket Query, you can add/remove multiple orderlines at once.