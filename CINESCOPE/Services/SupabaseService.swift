//
//  SupabaseService.swift
//  CINESCOPE
//
//  Created by Jimmy Aguilar on 4/3/26.
//



import Foundation
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://abazlrgfglodsiojfnex.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiYXpscmdmZ2xvZHNpb2pmbmV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUxOTkwMzYsImV4cCI6MjA5MDc3NTAzNn0.D7akn2QH1jbH1dxVRnaJzLKdoAvz6P0xinLcrwnH3CI"
        )
    }
}
