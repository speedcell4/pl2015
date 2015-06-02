Require Export Assignment10_07.

(* problem #08: 10 points *)

(** **** Exercise: 3 stars (eval__multistep)  *)
(** The key idea behind the proof comes from the following picture:
       P t1 t2 ==>            (by ST_Plus1) 
       P t1' t2 ==>           (by ST_Plus1)  
       P t1'' t2 ==>          (by ST_Plus1) 
       ...                
       P (C n1) t2 ==>        (by ST_Plus2)
       P (C n1) t2' ==>       (by ST_Plus2)
       P (C n1) t2'' ==>      (by ST_Plus2)
       ...                
       P (C n1) (C n2) ==>    (by ST_PlusConstConst)
       C (n1 + n2)              
    That is, the multistep reduction of a term of the form [P t1 t2]
    proceeds in three phases:
       - First, we use [ST_Plus1] some number of times to reduce [t1]
         to a normal form, which must (by [nf_same_as_value]) be a
         term of the form [C n1] for some [n1].
       - Next, we use [ST_Plus2] some number of times to reduce [t2]
         to a normal form, which must again be a term of the form [C
         n2] for some [n2].
       - Finally, we use [ST_PlusConstConst] one time to reduce [P (C
         n1) (C n2)] to [C (n1 + n2)]. *)

(** To formalize this intuition, you'll need to use the congruence
    lemmas from above (you might want to review them now, so that
    you'll be able to recognize when they are useful), plus some basic
    properties of [==>*]: that it is reflexive, transitive, and
    includes [==>]. *)

Theorem multistep_congr_1 : forall t1 t1' t2,
  t1 ==>* t1' -> P t1 t2 ==>* P t1' t2.
Proof.
  intros. induction H. constructor.
  apply multi_step with (P y t2). apply ST_Plus1. assumption.
  assumption.
Qed.

Theorem eval__multistep : forall t n,
  t || n -> t ==>* C n.
Proof.
  intros.
  induction H. constructor.
  assert (t1 || n1 -> P t1 t2 ==>* P (C n1) t2).
    intros. apply multistep_congr_1. assumption.
  apply multi_trans with (P (C n1) t2).
  apply H1. assumption.
  assert (t2 || n2 -> P (C n1) t2 ==>* P (C n1) (C n2)).
    intros. apply multistep_congr_2. constructor. assumption.
  apply multi_trans with (P (C n1) (C n2)).
  apply H2. assumption.
  apply multi_R. constructor.
Qed.

(*-- Check --*)
Check eval__multistep : forall t n,
  t || n -> t ==>* C n.

