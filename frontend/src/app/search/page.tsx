import { APISearchFetcher } from "../../services/searchfetcher/APISearchFetcher";
import { MockSearchFetcher } from "../../services/searchfetcher/MockSearchFetcher";
// Disable rule to allow server actions to be called without warning
/* eslint-disable react/jsx-no-bind, @typescript-eslint/no-misused-promises */
import React from "react";
import { SearchForm } from "./SearchForm";
import { fetchSearchOpportunities } from "../../services/searchfetcher/SearchFetcher";

const useMockData = false;
const searchFetcher = useMockData
  ? new MockSearchFetcher()
  : new APISearchFetcher();

// TODO: use for i18n when ready
// interface RouteParams {
//   locale: string;
// }

export default async function Search() {
  const initialSearchResults = await fetchSearchOpportunities(searchFetcher);
  return (
    <>
      <SearchForm initialSearchResults={initialSearchResults} />
    </>
  );
}