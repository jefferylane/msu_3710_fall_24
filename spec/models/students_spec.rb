require 'rails_helper'
 
#request specs for the Students resource focusing on HTTP requests
RSpec.describe "Students", type: :request do

  # GET /students (index)
  describe "GET /students" do
    context "when students exist" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", graduation_date: "2025-05-15") }

      # Test 1: Returns a successful response and displays the search form
      it "returns a successful response and displays the search form" do
        get students_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Search') # Ensure search form is rendered
      end

      # Test 2: Ensure it does NOT display students without a search
      it "does not display students until a search is performed" do
        get students_path
        expect(response.body).to_not include("Aaron")
      end
    end

    # Test 3: Handle missing records or no search criteria provided
    context "when no students exist or no search is performed" do
      it "displays a message prompting to search" do
        get students_path
        expect(response.body).to include("Please enter search criteria to find students")
      end
    end
  end

  # Search functionality
  describe "GET /students (search functionality)" do
    let!(:student1) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", graduation_date: "2025-05-15") }
    let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", graduation_date: "2026-05-15") }

    # Test 4: Search by major
    it "returns students matching the major" do
      get students_path, params: { search: { major: "Computer Science BS" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 5: Search by expected graduation date (before)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { graduation_date: "2026-01-01", date_type: "before" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 6: Search by expected graduation date (after)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { graduation_date: "2026-01-01", date_type: "after" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

  end

  # POST /students (create)
  describe "POST /students" do
    context "with valid parameters" do
      # Test 7: Create a new student and ensure it redirects
      it "creates a new student and redirects" do
        expect {
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", graduation_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)  # Expect redirect after creation
        follow_redirect!
        expect(response.body).to include("Aaron")  # Student's details in the response
      end

      # Test 8 (Student will complete this part)
      # Ensure that it returns a 201 status or check for creation success
      it "creates a new student and returns a 201 status" do
        # Set up valid student parameters
        student_params = {
          first_name: "Aaron",
          last_name: "Gordon",
          school_email: "gordon@msudenver.edu",
          major: "Computer Science BS",
          graduation_date: "2025-05-15"
        }
      
        # Make a POST request to create a new student
        post students_path, params: { student: student_params }
      
        # Expect the response to have a 201 status code
        expect(response).to have_http_status(:created) # or :success depending on how your controller responds
      
        # Optionally check that the student has been created in the database
        expect(Student.last.first_name).to eq("Aaron")
      end
    end

    context "with invalid parameters" do
      # Test 9 (Student will complete this part)
      # Ensure it does not create a student and returns a 422 status
      it "does not create a student with invalid parameters and returns a 422 status" do
        # Set up invalid student parameters (e.g., missing required fields)
        invalid_student_params = {
          first_name: "", # Invalid as first name is required
          last_name: "Smith",
          school_email: "john@msudenver.edu",
          major: "Mathematics BS",
          graduation_date: "2025-04-30"
        }
      
        # Make a POST request with invalid parameters
        post students_path, params: { student: invalid_student_params }
      
        # Expect the response to have a 422 status code
        expect(response).to have_http_status(:unprocessable_entity) # or :unprocessable if defined
      
        # Ensure that the Student count has not changed
        expect(Student.count).to eq(0)
      end
    end
  end

  # GET /students/:id (show)
  describe "GET /students/:id" do
    context "when the student exists" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", graduation_date: "2025-05-15") }

      # Test 10 (Student will complete this part)
      # Ensure it returns a successful response (200 OK)
      it "returns a 200 OK status when the student exists" do
        # Make a GET request to fetch the student's details using the student's ID
        get student_path(student)  # Assuming student_path is the correct route helper
      
        # Expect the response to have a 200 status code
        expect(response).to have_http_status(:ok)
      end

      # Test 11 (Student will complete this part)
      # Ensure it includes the student's details in the response body
      it "includes the student's details in the response body" do
        # Make a GET request to fetch the student's details using the student's ID
        get student_path(student)
      
        # Expect the response body to include the student's details
        expect(response.body).to include(student.first_name)
        expect(response.body).to include(student.last_name)
        expect(response.body).to include(student.school_email)
        expect(response.body).to include(student.major)
        expect(response.body).to include(student.graduation_date.strftime('%B %d, %Y'))  # Format the date as needed
      end
    end

    # Test 12: Handle missing records
    it "returns a 404 Not Found status when the student does not exist" do
      # Try to get a student with an ID that does not exist
      get student_path(id: -1)  # Assuming -1 is not a valid ID
      expect(response).to have_http_status(:not_found)  # Expect 404 Not Found status
    end

  end

  # DELETE /students/:id (destroy)
  describe "DELETE /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", graduation_date: "2025-05-15") }

    # Test 13: Deletes the student and redirects
    it "deletes the student and redirects" do
      expect {
        delete student_path(student)  # Use the path helper for the DELETE request
      }.to change(Student, :count).by(-1)  # Expect the count to decrease by 1
    
      expect(response).to have_http_status(:found)  # Expect a redirect after deletion
      follow_redirect!  # Follow the redirect
      expect(response).to have_http_status(:ok)  # Ensure the response is OK
      expect(response.body).to include("Students")  # Adjust this line to check for a specific phrase in the redirected page
    end

    # Test 14: Returns a 404 when trying to delete a non-existent student
    it "returns a 404 status when trying to delete a non-existent student" do
      delete "/students/9999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
