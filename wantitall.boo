#Copyright 2012 Alejandro Sánchez (http://alsanchez.es)

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
import System
import System.Text.RegularExpressions
import AlbumArtDownloader.Scripts
import util

class WantItAll(AlbumArtDownloader.Scripts.IScript, ICategorised):
	Name as string:
		get: return "WantItAll"
	Version as string:
		get: return "0.1"
	Author as string:
		get: return "alsanchez"
	Category as string:
		get: return "South African"
		
	def Search(artist as string, album as string, results as IScriptResults):
	
		artist = StripCharacters("&.'\";:?!", artist)
		album = StripCharacters("&.'\";:?!", album)
		
		searchString = artist + " " + album
		searchString = searchString.Trim().ToLower().Replace(" ", "-")
		
		searchUrl = String.Format("http://www.wantitall.co.za/{0}/Music/p1", searchString)
		html = GetPage(searchUrl)
		
		re = Regex("<li class=\"aproduct\"><a href=\"(?<productPageUrl>/Music[^\"]+)\">.+?<img src=\"(?<thumbnailUrl>[^\"]+)\" alt=\"(?<name>[^\"]+)\"")
		matches = re.Matches(html)
		
		results.EstimatedCount = matches.Count
		
		for match in matches:
			name = match.Groups["name"].Value
			productPageUrl = "http://www.wantitall.co.za" + match.Groups["productPageUrl"].Value
			thumbnailUrl = match.Groups["thumbnailUrl"].Value
			
			if thumbnailUrl != "http://www.wantitall.co.za//images/no_image_small.jpg":
				results.Add(thumbnailUrl, name, productPageUrl, -1, -1, thumbnailUrl, CoverType.Front)

	def RetrieveFullSizeImage(thumbnailUrl): 
	
		return thumbnailUrl.Replace("._SL75_","")