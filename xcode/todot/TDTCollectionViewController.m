//
//  TDTCollectionViewController.m
//  todot
//
//  Created by Rodrigo K on 2/22/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import "TDTCollectionViewController.h"
#import "TDTAppDelegate.h"
#import "Tasks.h"
#import "RKArkView.h"
#import "UIColor+hexString.h"

@interface TDTCollectionViewController () {
    CGPoint originalPosition;
    UIColor *originalColor;
    NSManagedObjectContext *context;
    NSArray *tasks;
    
    UIColor *lightColor;
    UIColor *notSoLightColor;
    UIColor *iNeedToDoColor;
    UIColor *urgentColor;
    UIColor *doneColor;
    IBOutlet UITextField *addTextField;
}

@end

@implementation TDTCollectionViewController

static NSString * CellIdentifier = @"cellIdentifier";


- (void)changeToolbarToEditing: (BOOL) editing {
    if (editing) {
        addTextField.hidden = NO;
        [addTextField becomeFirstResponder];
        UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addButtonAction:)];
        self.navigationItem.rightBarButtonItem = buttonAdd;
        buttonAdd.tag = 1;
        return;
    }
    
    addTextField.hidden = YES;
    [addTextField endEditing:YES];
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonAdd;
    buttonAdd.tag = 0;
}

- (void)addButtonAction:(id)sender {
    if (((UIBarButtonItem *)sender).tag == 0) {
        [self changeToolbarToEditing:YES];
        return;
    }
    
    [self changeToolbarToEditing:NO];
    
    [self saveNewTask];
}

- (void)saveNewTask {
    Tasks *task = (Tasks *)[NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:context];
    
	task.name = addTextField.text;
    
    NSError *error;
    if (![context save:&error]) {
    }
    [self getData];
    [self.collectionView reloadData];
    addTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self changeToolbarToEditing:NO];
    [self saveNewTask];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lightColor = [UIColor colorWithHexString:@"#BBB218"];
    notSoLightColor = [UIColor colorWithHexString:@"#C5961C"];
    iNeedToDoColor = [UIColor colorWithHexString:@"#AE6122"];
    urgentColor = [UIColor colorWithHexString:@"#C5321C"];
    doneColor = [UIColor colorWithHexString:@"#04A3AE"];
    
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonAdd;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestures)];
    gesture.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:gesture];
    
    
//    NSError *error;
    

    
    // Buscar o Contexto
	context = [(TDTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    [self getData];
	
//	// Marcas
//	Tasks *honda = (Tasks *)[NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:context];
//	honda.name = [NSString stringWithFormat:@"Teste %d", tasks.count];
//	
//    Tasks *ford = (Tasks *)[NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:context];
//	ford.name = [NSString stringWithFormat:@"Teste %d", tasks.count + 1];
	
	
	// Busca os objetos
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
//	// Salva o Contexto
//	if (![context save:&error])
//	{
//		NSLog(@"Erro ao salvar: %@", [error localizedDescription]);
//	}
//	else
//	{
//		NSLog(@"Salvo com sucesso!");
//	}
//    
    [self getData];
}

- (void)gestures {
    [self changeToolbarToEditing:NO];
}

- (void)getData {
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
	// Listar os objetos
    tasks = [context executeFetchRequest:fetchRequest error:&error];
//	for (Tasks *task in tasks)
//	{
//		//NSLog(@"Modelo: %@ %@",modelo.daMarca.nome, modelo.nome);
//		[task name];
//		
//		// Deletar objeto
//        //		[context deleteObject:task];
//	}

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return tasks.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Tasks *task = (Tasks *)[tasks objectAtIndex:indexPath.row];
    
    UILabel *text = (UILabel *) [otherCell viewWithTag:200];
    text.text = [task name];

    
    RKArkView *dot = (RKArkView *) [otherCell viewWithTag:100];
    dot.strokeColor = lightColor;
    dot.radius = 5;
    dot.strokeWidth = 10;
    
    RKArkView *circle1 = (RKArkView *) [otherCell viewWithTag:300];
    circle1.strokeColor = lightColor;
    RKArkView *circle2 = (RKArkView *) [otherCell viewWithTag:400];
    circle2.strokeColor = notSoLightColor;
    RKArkView *circle3 = (RKArkView *) [otherCell viewWithTag:500];
    circle3.strokeColor = iNeedToDoColor;
    RKArkView *circle4 = (RKArkView *) [otherCell viewWithTag:600];
    circle4.strokeColor = urgentColor;
    RKArkView *circle5 = (RKArkView *) [otherCell viewWithTag:700];
    circle5.strokeColor = doneColor;
    
    NSArray *circles = @[circle1,circle2,circle3,circle4,circle5];
    
    for (int i = 0; i < circles.count; i++) {
        RKArkView *c = [circles objectAtIndex:i];
        c.strokeWidth = 2;
        c.radius = 12;
    }
    
    if ([task color] != nil) {
        UIColor *color = [UIColor colorWithCIColor:[CIColor colorWithString:task.color]];
        text.textColor = [UIColor colorWithCGColor:color.CGColor];
        dot.strokeColor = text.textColor;
    } else {
        text.textColor = lightColor;
        dot.strokeColor = lightColor;
    }
        
    
    if ([[dot gestureRecognizers] count] == 0) {
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObject:)];
        pan.minimumNumberOfTouches = 1;
        [dot addGestureRecognizer:pan];
    }
    
    [self changeToolbarToEditing:NO];
    
    return otherCell;
}

-(void)moveObject:(UIPanGestureRecognizer *)pan;
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        originalPosition = pan.view.center;
        originalColor = [((RKArkView *)pan.view) strokeColor];
    }
    
    UIColor *newColor = originalColor;
    
    CGPoint location = [pan locationInView:pan.view.superview];
    
    UILabel *label = (UILabel *) [pan.view.superview viewWithTag:200];

    CGFloat alpha = 1 - (location.x - originalPosition.x) / 50;
    if (alpha > 1) {
        alpha = 1;
    } else if (alpha < 0) {
        alpha = 0;
    }

    label.alpha = alpha;
    
    UILabel *dot1 = (UILabel *) [pan.view.superview viewWithTag:300];
    UILabel *dot2 = (UILabel *) [pan.view.superview viewWithTag:400];
    UILabel *dot3 = (UILabel *) [pan.view.superview viewWithTag:500];
    UILabel *dot4 = (UILabel *) [pan.view.superview viewWithTag:600];
    UILabel *dot5 = (UILabel *) [pan.view.superview viewWithTag:700];
    
    alpha = (location.x - originalPosition.x) / 100;
    if (alpha > 1) {
        alpha = 1;
    } else if (alpha < 0) {
        alpha = 0;
    }
                              
    dot1.alpha = alpha;
    dot2.alpha = alpha;
    dot3.alpha = alpha;
    dot4.alpha = alpha;
    dot5.alpha = alpha;

    
    NSArray *dots = @[dot1, dot2, dot3, dot4, dot5];
    
    for (int i = 0; i < dots.count; i++) {
        RKArkView *dot = [dots objectAtIndex:i];
        if (location.x > dot.center.x - 22 && location.x < dot.center.x + 22) {
            location.x = dot.center.x;
            newColor = dot.strokeColor;
            break;
        }
    }

    location.y = pan.view.center.y;

    
    if (ABS(pan.view.center.x - location.x) > 21) {
        [UIView animateWithDuration: 0.3
                         animations: ^ {
                             pan.view.center = location;
                         }
                         completion: ^(BOOL finished) {
                             if (finished == YES) {
                                 ((RKArkView *)pan.view).strokeColor = newColor;
                             }
                         }];

    } else {
        pan.view.center = location;
//        ((UILabel *)pan.view).textColor = newColor;
    }

    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration: 0.2
                              delay: 0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations: ^ {
                             pan.view.center = originalPosition;
//                             ((UILabel *)pan.view).textColor = originalColor;
                             label.textColor = ((RKArkView *)pan.view).strokeColor;
                             
                              NSIndexPath *indexPath = [self.collectionView indexPathForCell: (UICollectionViewCell *)pan.view.superview.superview];
                             
                             Tasks *task = [tasks objectAtIndex:indexPath.row];
                             task.color = [[CIColor colorWithCGColor:label.textColor.CGColor] stringRepresentation];
                             NSError *error;
                             [context save:&error];
                             
                         }
                         completion: ^(BOOL finished) {

                         }];
    
        [UIView animateWithDuration: 0.2
                         animations: ^ {
                             label.alpha = 1;
                             dot1.alpha = 0;
                             dot2.alpha = 0;
                             dot3.alpha = 0;
                             dot4.alpha = 0;
                             dot5.alpha = 0;
                         }
                         completion: ^(BOOL finished) {
                             
                         }];
    }
}


@end
