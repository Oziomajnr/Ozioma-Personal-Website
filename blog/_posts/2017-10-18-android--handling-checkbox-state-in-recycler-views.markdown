---
layout:	post
title:	"Android: Handling Checkbox state in Recycler Views."
date:	2017-10-18
---

b'\n\n\n\nIn Android development, developers usually have to handle some sort of selection from a list of items. When these items could potentially become many, then a Recycler view is usually a good choice for holding these items because it recycles it’s content and thus improves performance. But since Recycler view recycles it’s items, views that have toggling behaviour(check boxes, switches erc) usually behave unpredictably with Recycler Views this especially happens when developers do not handle the logic of displaying the current state of the view (checked/unchecked)

The common way a developer can go about setting the state of the view is set it to checked when the view is clicked then uncheck it when the view is clicked again by checking the previous state of the view.

i.e

**if **(**mCheckedView**.isChecked()) {  
 **mCheckedView**.setChecked(**false**);*  
*}  
**else **{  
 **mCheckedView**.setChecked(**true**);*  
*}This logic might appear correct but it is not, when you scroll down the Recycler view such that the current view is no longer visible, it usually reuses the state the view to set the state of some other view down the list, this can also happens when the keyboard input covers the view. You get a similar behavior to this animation.

![](/img/1*gNSazrkWiBdW64CbRw7ljA.gif)So how do we handle this problem?

We would consider 2 options

1. Block the view holder from recycling it’s views. (DON’T DO THIS)
2. Use your model to hold the state of the items.
3. Use an array to hold the state of the items.
1.** Block the View Holder from recycling it’s views.**

You can achieve this by setting the isRecycleable property of the Recycler view view holder to false, this would prevent the Recycler view from recycling it’s content. In the constructor of the view holder add the following line.

ViewHolder(View itemView) {  
 **super**(itemView);  
 ...  
 **this**.setIsRecyclable(**false**);  
}This is a bad idea because the reason why you are using the Recycler view in the first place is to take advantage of its Recyclable property. So this is an option, but it is not recommended. It solves the problem of using the wrong state for the wrong views but when the views goes out of visibility they return to their default state.

![](/img/1*gNSazrkWiBdW64CbRw7ljA.gif)behavior after method 1So we need a sort of memory to hold the current state of each item in the view.

2. **Use your model to hold the current state of the view.**

You could have a Boolean field in your model for the Recycler View to hold the state of your current item.So in your Model class you can have

**private **boolean **isChecked**;  
  
**public **boolean getChecked() {  
 **return isChecked**;  
}  
  
**public void **setChecked(boolean checked) {  
 **isChecked **= checked;  
}then when in the click even handler of the view you can toggle this property of the item like this:

@Override  
**public void **onClick(View v) {  
 *// toggle the checked view based on the checked field in the model  
 ***int **adapterPosition = getAdapterPosition();  
 **if **(**items**.get(adapterPosition).getChecked()) {  
 **mCheckedTextView**.setChecked(**false**);  
 **items**.get(adapterPosition).setChecked(**false**);  
 }  
 **else **{  
 **mCheckedTextView**.setChecked(**true**);  
 **items**.get(adapterPosition).setChecked(**true**);  
 }  
}then we have to make sure the correct state is displayed when the view is bound like this

@Override  
**public void **onBindViewHolder(ViewHolder holder, **int **position) {  
 holder.bind(position);  
}**class **ViewHolder **extends **RecyclerView.ViewHolder **implements **View.OnClickListener {  
  
 CheckedTextView **mCheckedTextView**;  
  
 ViewHolder(View itemView) {  
 **super**(itemView);  
 **mCheckedTextView **= (CheckedTextView) itemView.findViewById(R.id.***checked\_text\_view***);  
 itemView.setOnClickListener(**this**);  
 }  
  
 **void **bind(**int **position) {  
 **mCheckedTextView**.setText(String.*valueOf*(**items**.get(position).getPosition()));  
 **if **(**items**.get(position).getChecked()) {  
 **mCheckedTextView**.setChecked(**true**);  
 }  
 **else **{  
 **mCheckedTextView**.setChecked(**false**);  
 }  
 }...this correctly displays the correct state for the correct view.

The disadvantage of this method is that the model is now aware of the view and this might not be a very good software design, so the last method would make sure the state of the views are stored in the adapter.

3.** Use an array to hold the state of the items.**

To do this, in the adapter we use a Map or a [SparseBooleanArray](https://developer.android.com/reference/android/util/SparseBooleanArray.html) (which is similar to a map but is a key value pair of int and boolean)to store the state of all the items in our list of items and then use the keys and values to compare when toggling the checked state.

In the Adapter create a SparseBooleanArray

declare a spare boolean array to hold the state of the itemsthen in the item click handler onClick() use the state of the items in the itemStateArray to check before toggling, here is an example

also use the sparse boolean array to set the checked state when the view is bound

I prefer using this method since it does everything in the Adapter and does not interfere with the model.

![](/img/1*ytOlUmus17Un5FUytrSoyA.gif)behavior of the views after method 2 and 3from the animation above, notice how the state of the check boxes are retained even after the views are recycled.

I have created a github repo with the source code for this tutorial

[**Oziomajnr/RecyclerViewCheckBoxExample2**  
*RecyclerViewCheckBoxExample2 - Supporting article for the medium tutorial on how to handle check box states in android…*github.com](https://github.com/Oziomajnr/RecyclerViewCheckBoxExample2/tree/with-sparse-boolean-array "https://github.com/Oziomajnr/RecyclerViewCheckBoxExample2/tree/with-sparse-boolean-array")[](https://github.com/Oziomajnr/RecyclerViewCheckBoxExample2/tree/with-sparse-boolean-array)it has 3 branches each demonstrating the 3 methods listed in this article, feel free to submit contributions in the repo if you know other methods for solving this problem.

Please feel free to comment if you have problem implementing this solution.

\n\n'