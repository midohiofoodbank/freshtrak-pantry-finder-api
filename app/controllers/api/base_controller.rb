# frozen_string_literal: true

module Api
  # Base controller for api namespace
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :missing_record

    private

    def missing_record
      render json: { message: "Couldn't find Record" }, status: 404
    end
  end
end
