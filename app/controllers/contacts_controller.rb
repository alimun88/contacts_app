class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @contacts = Contact.paginate(page: params[:page], per_page: 5)
  end
    
  def new
    @contact = Contact.new
  end
    
  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user
    if @contact.save
      flash[:success] = "Contact was created successfully"
      redirect_to contact_path(@contact)
    else
      render 'new'
    end
  end
  
  def edit 
   
  end
  
  def update
    if @contact.update(contact_params)
      flash[:success] = "Contact was updated successfully"
      redirect_to contact_path(@contact)
    else
      render 'new'
    end
  end
  
  def show
  
  end
  
  def destroy
    @contact.destroy
    
    flash[:danger] = "Contact was successfully deleted"
    redirect_to contacts_path
  end
  
  def set_contact
     @contact = Contact.find(params[:id])
  end
  
  def contact_params
    params.require(:contact).permit(:first_name, :middle_name, :last_name, :street_number, :street_name, :address2, :city, :state, :zipcode, :home_phone, :mobile_phone, :country)
  end
  
  def require_same_user
    if current_user != @contact.user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own contact!"
      redirect_to root_path
    end
  end
  
end