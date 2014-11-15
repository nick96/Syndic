(** [Syndic.Opml1]: compliant with
    {{:http://dev.opml.org/spec1.html} OPML 1.0}. *)

module Error : module type of Syndic_error

type head =
  {
    title : string;  (** Title of the document. *)
    date_created : CalendarLib.Calendar.t;
    (** A date-time indicating when the document was created. *)
    date_modified : CalendarLib.Calendar.t;
    (** A date-time indicating when the document was last modified. *)
    owner_name : string;  (** Owner of the document. *)
    owner_email : string; (** Email address of the owner of the document. *)
    expansion_state : int list;
    (** A comma-separated list of line numbers that are expanded.  The
        line numbers in the list tell you which headlines to expand.
        The order is important.  For each element in the list, X,
        starting at the first summit, navigate flatdown X times and
        expand.  Repeat for each element in the list. *)
    vert_scroll_state : int;
    (** A number saying which line of the outline is displayed on the
        top line of the window. This number is calculated with the
        expansion state already applied. *)
    window_top : int;    (** Pixel location of the top edge of the window. *)
    window_left : int;   (** Pixel location of the left edge of the window. *)
    window_bottom : int; (** Pixel location of the bottom edge of the window. *)
    window_right : int   (** Pixel location of the right edge of the window. *)
  }

type outline =
  {
    text : string option;
    (** String that's displayed when the outline is being browsed or edited.
        There is no specific limit on the length of the text attribute.*)
    type_ : string option;
    (** Says how other attributes of the [outline] are interpreted. *)
    is_comment : bool;
    (** Indicates whether the outline is commented or not.  By convention
        if an outline is commented, all subordinate outlines are considered
        to be commented as well. *)
    is_breakpoint : bool;
    (** Indicates whether a breakpoint is set on this outline.  This
        attribute is mainly necessary for outlines used to edit scripts
        that execute. *)
    outlines : outline list;
    (** List of [outline] elements that are considered sub-items of
        the current outline. *)
  }

type body = outline list (** List of outline elements. *)

type opml =
  {
    version : string;
    (** Tells version of OPML document (should be 1.0 or 1.1) *)
    head : head;
    body : body;
  }

val parse : Xmlm.input -> opml
(** [parse i] takes [i] and returns an opml record which is the OCaml
    representation of the OPML document. *)



(**/**)

val unsafe : Xmlm.input ->
  [> `Opml of
       [> `Body of
            [> `Outline of
                 [> `IsBreakpoint of string
                 | `IsComment of string
                 | `Outline of 'a
                 | `Text of string
                 | `Type of string ]
                   list as 'a ]
              list
       | `Head of
            [> `DateCreated of string
            | `DateModified of string
            | `ExpansionSate of string
            | `OwnerEmail of string
            | `OwnerName of string
            | `Title of string
            | `VertScrollState of string
            | `WindowBottom of string
            | `WindowLeft of string
            | `WindowRight of string
            | `WindowTop of string ]
              list
       | `Version of string ]
         list ]
(** Analysis without verification. *)
