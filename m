Return-Path: <SRS0=HiQF=K5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbeHOAJQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Aug 2018 20:09:16 -0400
Date: Tue, 14 Aug 2018 17:20:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 02/14] tools/lib/traceevent, tools/perf: Rename struct
 format to struct tep_format and struct format_field to struct
 tep_format_field
Message-ID: <20180814172010.6b8713fc@gandalf.local.home>
In-Reply-To: <20180810131732.24677-3-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
        <20180810131732.24677-3-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 10 Aug 2018 16:17:20 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


I renamed the subject to:

tools/lib/traceevent, tools/perf: Rename struct format{_field} to struct tep_format{_field}

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_". This renames struct format to
> struct tep_format and struct format_field to struct tep_format_field
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tools/lib/traceevent/event-parse.c            | 82 +++++++++----------
>  tools/lib/traceevent/event-parse.h            | 42 +++++-----
>  tools/lib/traceevent/parse-filter.c           |  8 +-
>  tools/lib/traceevent/plugin_kmem.c            |  2 +-
>  tools/lib/traceevent/plugin_mac80211.c        |  2 +-
>  tools/lib/traceevent/plugin_sched_switch.c    |  6 +-
>  tools/perf/builtin-trace.c                    | 22 ++---
>  tools/perf/tests/evsel-tp-sched.c             |  2 +-
>  tools/perf/util/data-convert-bt.c             | 22 ++---
>  tools/perf/util/evsel.c                       |  8 +-
>  tools/perf/util/evsel.h                       |  6 +-
>  tools/perf/util/evsel_fprintf.c               |  2 +-
>  tools/perf/util/python.c                      |  4 +-
>  .../util/scripting-engines/trace-event-perl.c |  4 +-
>  .../scripting-engines/trace-event-python.c    |  6 +-
>  tools/perf/util/sort.c                        | 18 ++--
>  tools/perf/util/trace-event-parse.c           |  4 +-
>  17 files changed, 120 insertions(+), 120 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 1874c249a963..40bad7b7533a 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -1312,7 +1312,7 @@ static int event_read_id(void)
>  	return -1;
>  }
>  


> @@ -3880,7 +3880,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  {
>  	struct tep_handle *pevent = event->pevent;
>  	struct print_flag_sym *flag;
> -	struct format_field *field;
> +	struct tep_format_field *field;

Note, since we made it to be tep_format_field *field, which makes field
go past flag, ideally, we would move it before flag (to keep the nice
"upside-down-xmas-tree" formatting). But since we are going to rename
print_flag_sym anyway it's fine for now. Just an FYI.

No need to resend over this. Just letting you know.

-- Steve


>  	struct printk_map *printk;
>  	long long val, fval;
>  	unsigned long long addr;
> @@ -4021,7 +4021,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  
>  		if (arg->int_array.field->type == PRINT_DYNAMIC_ARRAY) {
>  			unsigned long offset;
> -			struct format_field *field =
> +			struct tep_format_field *field =
>  				arg->int_array.field->dynarray.field;
>  			offset = tep_read_number(pevent,
>  						 data + field->offset,
> @@ -4069,7 +4069,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  		int str_offset;
>  
>  		if (arg->string.offset == -1) {
> -			struct format_field *f;
> +			struct tep_format_field *f;
>  
>  			f = tep_find_any_field(event, arg->string.string);
>  			arg->string.offset = f->offset;
> @@ -4087,7 +4087,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  		int bitmask_size;
>  
>  		if (arg->bitmask.offset == -1) {
> -			struct format_field *f;
> +			struct tep_format_field *f;
>  
>  			f = tep_find_any_field(event, arg->bitmask.bitmask);
>  			arg->bitmask.offset = f->offset;
