// Watermelon
/obj/item/seeds/watermelon
	name = "pack of watermelon seeds"
	desc = "These seeds grow into watermelon plants."
	icon_state = "seed-watermelon"
	species = "watermelon"
	plantname = "Watermelon Vines"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	lifespan = 50
	endurance = 40
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	mutatelist = list(/obj/item/seeds/watermelon/holy)
	reagents_add = list("vitamin" = 0.08, "nutriment" = 0.4)

/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	seed = /obj/item/seeds/watermelon
	name = "watermelon"
	desc = "It's full of watery goodness."
	icon_state = "watermelon"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	slices_num = 5
	dried_type = null
	w_class = 3
	filling_color = "#008000"
	bitesize_mod = 3
	foodtype = FRUIT

// Holymelon
/obj/item/seeds/watermelon/holy
	name = "pack of holymelon seeds"
	desc = "These seeds grow into holymelon plants."
	icon_state = "seed-holymelon"
	species = "holymelon"
	plantname = "Holy Melon Vines"
	product = /obj/item/weapon/reagent_containers/food/snacks/grown/holymelon
	mutatelist = list()
	reagents_add = list("holywater" = 0.4, "vitamin" = 0.08, "nutriment" = 0.2)
	rarity = 20

/obj/item/weapon/reagent_containers/food/snacks/grown/holymelon
	seed = /obj/item/seeds/watermelon/holy
	name = "holymelon"
	desc = "The water within this melon has been blessed by some deity that's particularly fond of watermelon."
	icon_state = "holymelon"
	filling_color = "#FFD700"
	dried_type = null
