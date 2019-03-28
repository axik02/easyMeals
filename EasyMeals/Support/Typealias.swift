import Foundation


// MARK : Dictionaries
typealias JSONParameters = [String:Any]

// MARK : Closures
typealias DownloadComplete = () -> ()

// MARK : Fetch Completed
typealias UserFetchCompleted = (RequestResult<User>) -> ()
typealias CategoriesFetchCompleted = (RequestResult<Categories>) -> ()
typealias RecipesFetchCompleted = (RequestResult<Recipes>) -> ()
typealias RecipeFetchCompleted = (RequestResult<Recipe>) -> ()
typealias ResultWithFile = (RequestResult<File>) -> ()
typealias QuantitiesFetchCompleted = (RequestResult<MealQuantities>) -> ()
typealias VarietiesFetchCompleted = (RequestResult<MealVarieties>) -> ()
typealias RecipePDFCreateCompleted = (RequestResult<RecipePDF>) -> ()
typealias MenuGenerateCompleted = (RequestResult<Void>) -> ()
typealias MenuRecipesFetchCompleted = (RequestResult<MenuRecipes>) -> ()
typealias MenuRecipeFetchCompleted = (RequestResult<SingleMenuRecipe>) -> ()
typealias RecipeDeleteCompleted = (RequestResult<String>) -> ()
