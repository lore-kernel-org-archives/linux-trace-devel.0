Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DF3812CD
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780081893; cv=none; b=h8gtk4w2MDaeKnjsi4lhSIXDQoPJ1XEXaPhVpiHCXccfu1AQK67T06w9KIMtPAKhoZ0LYHAGON+0dki0PoiZ4SH7n3BSe2ptCjg9ZG391m9QDxYa3sF6iPxZ3MmMiUWI7gz+1FhiVdaXhgG2/aW1ck0qVWhdzx2HTDE05e4h9nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780081893; c=relaxed/simple;
	bh=emdm8r5g2F5lpGMl/GKLxhu+TL/w4Rbh141VZpzoLtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8X+XmZ6Gi05Sp39g4igFyt1pzFvwcgsCAvj1Z3CjEbW39Kig+xHKIR60pwsl4CL9EZXsmrzi3DApGDmhMZOQeUZs/xFlU7PI/h8X9QY2O1+wOGwkX1PNm1YW7T5fqiIMpg08A/6LLklKPwCEkXLQhCoiVyhgTRINkavQaWtSXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95E86402B9;
	Fri, 29 May 2026 19:11:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 1916B20026;
	Fri, 29 May 2026 19:11:28 +0000 (UTC)
Date: Fri, 29 May 2026 15:11:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: CaoRuichuang <create0818@163.com>
Cc: linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] libtraceevent: reject non-text symbol arithmetic
Message-ID: <20260529151126.392e2a70@fedora>
In-Reply-To: <20260406123017.10928-1-create0818@163.com>
References: <20260406123017.10928-1-create0818@163.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1916B20026
X-Stat-Signature: fgdakf8gp5h9in5fabo4m9cief8szx3c
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19cUosBGjQ8Qk2Dio8wjC5qezGTCt3IO5c=
X-HE-Tag: 1780081888-68732
X-HE-Meta: U2FsdGVkX18sqs6RKQR38xlRSaQ9w2DuqMHD6CDijyxG6y00Xxik321OHRcJJPNTj1LH2Be8QWM4iLTEcUMLIlnvv4iQB6i6AcCQJsHlJXLjmwau3qVlaXabKlG74qKGGfcYc0AxTg3jxYGgmGR0zJkYy2YIoEKYEz/uQ28BsYf8Kq+aiGl/Q1XeEB4kdXWTvzC3tu9Opnz36U7m0GD7qdOGkaTPX3RoOrbfSJ9RtUPqmrTTWdbB0PHlpJeuCHMhbB4Iexpu7nS1ewB8MmTrVeeHQF50OW1uTIwc8sM28tZMZXyFnHTg8vNyAKCQhG4BvB7ERxk8TmsSEq1OWsXpoWaAGYef/zCFZt+t0/fC8wZzKc1QJHOkQlkGWxfZgOIBZBE2qnF1dSg=

On Mon,  6 Apr 2026 20:30:17 +0800
CaoRuichuang <create0818@163.com> wrote:

> The print fmt parser currently treats any kallsyms entry as a function
> symbol and will substitute its address into numeric expressions.
> 
> That works for _stext based offsets, but it also turns runtime globals
> like jiffies into kernel virtual addresses. Events such as
> writeback_single_inode_start then report a huge bogus age value instead
> of something meaningful.
> 
> Only text symbols should be loaded into the function map from
> /proc/kallsyms. For any remaining bare identifier that cannot be
> resolved as a numeric value, mark that argument as invalid and print
> INVALID for that conversion instead of fabricating a number.
> 
> This keeps _stext style symbol arithmetic working while making the
> writeback age output fail in a local and explicit way.
> 
> Add unit tests for both the preserved _stext case and the rejected
> jiffies arithmetic case.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219839
> Signed-off-by: CaoRuichuang <create0818@163.com>
> ---
>  src/event-parse.c        | 109 +++++++++++++++++++++++++----
>  utest/traceevent-utest.c | 146 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 241 insertions(+), 14 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index fee0f91..60225ee 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -107,6 +107,7 @@ struct tep_mod_addr {
>  static unsigned long long
>  process_defined_func(struct trace_seq *s, void *data, int size,
>  		     struct tep_event *event, struct tep_print_arg *arg);
> +static bool is_kernel_text_symbol(char ch);
>  
>  static void free_func_handle(struct tep_function_handler *func);

There's no reason to add this prototype here and place the function
below. Could you resend this with the function is above where it is
used. That way you don't need the prototype.

The other functions prototypes above were added because the function
was already defined and then used by another function defined earlier.
I do this just to keep the diffstat down from moving the functions
around.

Also, rename the subject to:

  libtraceevent: Reject non-text symbol arithmetic

Thanks!

-- Steve

>  
> @@ -1070,6 +1071,10 @@ int tep_parse_kallsyms(struct tep_handle *tep,
> const char *kallsyms)
>  		 *  - x86-64 that reports per-cpu variable offsets
> as absolute */
>  		if (func[0] != '$' && ch != 'A' && ch != 'a') {
> +			if (!is_kernel_text_symbol(ch)) {
> +				line = strtok_r(NULL, "\n", &next);
> +				continue;
> +			}
>  			line[func_end] = 0;
>  			if (mod_end) {
>  				mod = line + mod_start;
> @@ -4579,14 +4584,30 @@ tep_find_event_by_name(struct tep_handle *tep,
>  	return event;
>  }
>  
> +static bool is_kernel_text_symbol(char ch)
> +{
> +	switch (ch) {
> +	case 'T':
> +	case 't':
> +	case 'W':
> +	case 'w':
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  static unsigned long long test_for_symbol(struct tep_handle *tep,
> -					  struct tep_print_arg *arg)
> +					  struct tep_print_arg *arg,
> +					  bool *found)
>  {
>  	unsigned long long val = 0;
>  	struct func_list *item = tep->funclist;
>  	char *func;
>  	int i;
>  
> +	*found = false;
> +
>  	if (isdigit(arg->atom.atom[0]))
>  		return 0;
>  
> @@ -4607,10 +4628,14 @@ static unsigned long long
> test_for_symbol(struct tep_handle *tep, 
>  		if (strcmp(arg->atom.atom, name) == 0) {
>  			val = addr;
> +			*found = true;
>  			break;
>  		}
>  	}
>  
> +	if (!*found)
> +		return 0;
> +
>  	/*
>  	 * This modifies the arg to hardcode the value
>  	 * and will not loop again.
> @@ -4686,13 +4711,17 @@ static bool check_data_offset_size(struct
> tep_event *event, const char *field_na }
>  
>  static unsigned long long
> -eval_num_arg(void *data, int size, struct tep_event *event, struct
> tep_print_arg *arg) +eval_num_arg_stat(void *data, int size, struct
> tep_event *event,
> +		  struct tep_print_arg *arg, bool *valid)
>  {
>  	struct tep_handle *tep = event->tep;
>  	unsigned long long val = 0;
>  	unsigned long long left, right;
>  	struct tep_print_arg *typearg = NULL;
>  	struct tep_print_arg *larg;
> +	bool found = false;
> +	bool left_valid = true;
> +	bool right_valid = true;
>  	unsigned int offset;
>  	unsigned int field_size;
>  
> @@ -4702,8 +4731,11 @@ eval_num_arg(void *data, int size, struct
> tep_event *event, struct tep_print_arg return 0;
>  	case TEP_PRINT_ATOM:
>  		val = strtoull(arg->atom.atom, NULL, 0);
> -		if (!val)
> -			val = test_for_symbol(tep, arg);
> +		if (!val && !isdigit(arg->atom.atom[0])) {
> +			val = test_for_symbol(tep, arg, &found);
> +			if (!found)
> +				*valid = false;
> +		}
>  		return val;
>  	case TEP_PRINT_FIELD:
>  		if (!arg->field.field) {
> @@ -4728,7 +4760,10 @@ eval_num_arg(void *data, int size, struct
> tep_event *event, struct tep_print_arg case TEP_PRINT_HEX_STR:
>  		break;
>  	case TEP_PRINT_TYPE:
> -		val = eval_num_arg(data, size, event,
> arg->typecast.item);
> +		val = eval_num_arg_stat(data, size, event,
> arg->typecast.item,
> +					valid);
> +		if (!*valid)
> +			return 0;
>  		return eval_type(val, arg, 0);
>  	case TEP_PRINT_STRING:
>  	case TEP_PRINT_BSTRING:
> @@ -4749,7 +4784,12 @@ eval_num_arg(void *data, int size, struct
> tep_event *event, struct tep_print_arg
>  			 * Arrays are special, since we don't want
>  			 * to read the arg as is.
>  			 */
> -			right = eval_num_arg(data, size, event,
> arg->op.right);
> +			right = eval_num_arg_stat(data, size, event,
> +						 arg->op.right,
> &right_valid);
> +			if (!right_valid) {
> +				*valid = false;
> +				return 0;
> +			}
>  
>  			/* handle typecasts */
>  			larg = arg->op.left;
> @@ -4797,17 +4837,34 @@ eval_num_arg(void *data, int size, struct
> tep_event *event, struct tep_print_arg val = eval_type(val, typearg,
> 1); break;
>  		} else if (strcmp(arg->op.op, "?") == 0) {
> -			left = eval_num_arg(data, size, event,
> arg->op.left);
> +			left = eval_num_arg_stat(data, size, event,
> arg->op.left,
> +						&left_valid);
> +			if (!left_valid) {
> +				*valid = false;
> +				return 0;
> +			}
>  			arg = arg->op.right;
>  			if (left)
> -				val = eval_num_arg(data, size,
> event, arg->op.left);
> +				val = eval_num_arg_stat(data, size,
> event,
> +
> arg->op.left, &left_valid); else
> -				val = eval_num_arg(data, size,
> event, arg->op.right);
> +				val = eval_num_arg_stat(data, size,
> event,
> +
> arg->op.right, &right_valid);
> +			if ((left && !left_valid) || (!left &&
> !right_valid)) {
> +				*valid = false;
> +				return 0;
> +			}
>  			break;
>  		}
>   default_op:
> -		left = eval_num_arg(data, size, event, arg->op.left);
> -		right = eval_num_arg(data, size, event,
> arg->op.right);
> +		left = eval_num_arg_stat(data, size, event,
> arg->op.left,
> +					 &left_valid);
> +		right = eval_num_arg_stat(data, size, event,
> arg->op.right,
> +					  &right_valid);
> +		if (!left_valid || !right_valid) {
> +			*valid = false;
> +			return 0;
> +		}
>  		switch (arg->op.op[0]) {
>  		case '!':
>  			switch (arg->op.op[1]) {
> @@ -4922,6 +4979,15 @@ out_warning_field:
>  	return 0;
>  }
>  
> +static unsigned long long
> +eval_num_arg(void *data, int size, struct tep_event *event,
> +	     struct tep_print_arg *arg)
> +{
> +	bool valid = true;
> +
> +	return eval_num_arg_stat(data, size, event, arg, &valid);
> +}
> +
>  struct flag {
>  	const char *name;
>  	unsigned long long value;
> @@ -6607,9 +6673,14 @@ static int print_function(struct trace_seq *s,
> const char *format, struct tep_print_arg *arg, bool raw)
>  {
>  	struct func_map *func;
> +	bool valid = true;
>  	unsigned long long val;
>  
> -	val = eval_num_arg(data, size, event, arg);
> +	val = eval_num_arg_stat(data, size, event, arg, &valid);
> +	if (!valid) {
> +		trace_seq_puts(s, "INVALID");
> +		return 0;
> +	}
>  	func = find_func(event->tep, val);
>  	if (func) {
>  		trace_seq_puts(s, func->func);
> @@ -6636,6 +6707,7 @@ static int print_arg_pointer(struct trace_seq
> *s, const char *format, int plen, struct tep_event *event, struct
> tep_print_arg *arg, bool raw)
>  {
> +	bool valid = true;
>  	unsigned long long val;
>  	int ret = 1;
>  
> @@ -6674,7 +6746,11 @@ static int print_arg_pointer(struct trace_seq
> *s, const char *format, int plen, break;
>  	default:
>  		ret = 0;
> -		val = eval_num_arg(data, size, event, arg);
> +		val = eval_num_arg_stat(data, size, event, arg,
> &valid);
> +		if (!valid) {
> +			trace_seq_puts(s, "INVALID");
> +			break;
> +		}
>  		trace_seq_printf(s, "%p", (void *)(intptr_t)val);
>  		break;
>  	}
> @@ -6687,9 +6763,14 @@ static int print_arg_number(struct trace_seq
> *s, const char *format, int plen, void *data, int size, int ls,
>  			    struct tep_event *event, struct
> tep_print_arg *arg) {
> +	bool valid = true;
>  	unsigned long long val;
>  
> -	val = eval_num_arg(data, size, event, arg);
> +	val = eval_num_arg_stat(data, size, event, arg, &valid);
> +	if (!valid) {
> +		trace_seq_puts(s, "INVALID");
> +		return 0;
> +	}
>  
>  	switch (ls) {
>  	case -2:
> diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
> index b62411c..473b9c7 100644
> --- a/utest/traceevent-utest.c
> +++ b/utest/traceevent-utest.c
> @@ -182,6 +182,74 @@ static char sizeof_data[] = {
>  };
>  static void *sizeof_event_data = (void *)sizeof_data;
>  
> +static const char symbol_kallsyms[] =
> +	"0000000000001000 T _stext\n"
> +	"0000000000001020 T do_work\n"
> +	"0000000000001100 T end_text\n"
> +	"0000000000002000 D jiffies\n";
> +
> +#define SYMBOL_ARITH_FMT "caller=do_work+0x0"
> +static const char symbol_arith_event[] =
> +	"name: symbol_arith\n"
> +	"ID: 24\n"
> +	"format:\n"
> +	"\tfield:unsigned short
> common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
> +	"\tfield:unsigned char
> common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
> +	"\tfield:unsigned char
> common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
> +	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
> +	"\n"
> +	"\tfield:unsigned int
> caller_off;\toffset:8;\tsize:4;\tsigned:0;\n"
> +	"\n"
> +	"print fmt: \"caller=%pS\", REC->caller_off + _stext\n";
> +
> +static char symbol_arith_data[] = {
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	/* common type */		24, 0x00,
> +#else
> +	/* common type */		0x00, 24,
> +#endif
> +	/* common flags */		0x00,
> +	/* common_preempt_count */	0x00,
> +	/* common_pid */		0x00, 0x00, 0x00, 0x00,
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	/* caller_off */		0x20, 0x00, 0x00, 0x00,
> +#else
> +	/* caller_off */		0x00, 0x00, 0x00, 0x20,
> +#endif
> +};
> +
> +#define JIFFIES_ARITH_FMT "age=INVALID"
> +static const char jiffies_arith_event[] =
> +	"name: jiffies_arith\n"
> +	"ID: 25\n"
> +	"format:\n"
> +	"\tfield:unsigned short
> common_type;\toffset:0;\tsize:2;\tsigned:0;\n"
> +	"\tfield:unsigned char
> common_flags;\toffset:2;\tsize:1;\tsigned:0;\n"
> +	"\tfield:unsigned char
> common_preempt_count;\toffset:3;\tsize:1;\tsigned:0;\n"
> +	"\tfield:int common_pid;\toffset:4;\tsize:4;\tsigned:1;\n"
> +	"\n"
> +	"\tfield:unsigned long
> dirtied_when;\toffset:8;\tsize:8;\tsigned:0;\n"
> +	"\n"
> +	"print fmt: \"age=%lu\", (jiffies - REC->dirtied_when) /
> 250\n"; +
> +static char jiffies_arith_data[] = {
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	/* common type */		25, 0x00,
> +#else
> +	/* common type */		0x00, 25,
> +#endif
> +	/* common flags */		0x00,
> +	/* common_preempt_count */	0x00,
> +	/* common_pid */		0x00, 0x00, 0x00, 0x00,
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	/* dirtied_when */		0xf4, 0x01, 0x00, 0x00,
> +					0x00, 0x00, 0x00, 0x00,
> +#else
> +	/* dirtied_when */		0x00, 0x00, 0x00, 0x00,
> +					0x00, 0x00, 0x01, 0xf4,
> +#endif
> +};
> +
>  DECL_CPUMASK_EVENT_DATA(full, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> 0xff, 0xff); #define CPUMASK_FULL     "ARRAY[ff, ff, ff, ff, ff, ff,
> ff, ff]" #define CPUMASK_FULL_FMT "cpumask=0-63"
> @@ -380,6 +448,80 @@ static void test_parse_sizeof_undef(void)
>  	test_parse_sizeof(0, 5, "sizeof_undef", SIZEOF_LONG0_FMT);
>  }
>  
> +static struct tep_handle *alloc_local_tep(void)
> +{
> +	struct tep_handle *tep = tep_alloc();
> +
> +#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +	if (tep)
> +		tep_set_file_bigendian(tep, TEP_BIG_ENDIAN);
> +#endif
> +	return tep;
> +}
> +
> +static void test_parse_symbol_offset(void)
> +{
> +	struct trace_seq seq;
> +	struct tep_handle *tep;
> +	struct tep_event *event;
> +	struct tep_record record = {
> +		.data = symbol_arith_data,
> +		.size = sizeof(symbol_arith_data),
> +	};
> +
> +	tep = alloc_local_tep();
> +	CU_TEST(tep != NULL);
> +	if (!tep)
> +		return;
> +
> +	trace_seq_init(&seq);
> +
> +	CU_TEST(tep_parse_kallsyms(tep, symbol_kallsyms) == 0);
> +	CU_TEST(tep_parse_format(tep, &event, symbol_arith_event,
> +				 strlen(symbol_arith_event),
> +				 "symbol") == TEP_ERRNO__SUCCESS);
> +
> +	trace_seq_reset(&seq);
> +	tep_print_event(tep, &seq, &record, "%s", TEP_PRINT_INFO);
> +	trace_seq_do_printf(&seq);
> +	CU_TEST(strcmp(seq.buffer, SYMBOL_ARITH_FMT) == 0);
> +
> +	trace_seq_destroy(&seq);
> +	tep_free(tep);
> +}
> +
> +static void test_parse_jiffies_arith_invalid(void)
> +{
> +	struct trace_seq seq;
> +	struct tep_handle *tep;
> +	struct tep_event *event;
> +	struct tep_record record = {
> +		.data = jiffies_arith_data,
> +		.size = sizeof(jiffies_arith_data),
> +	};
> +
> +	tep = alloc_local_tep();
> +	CU_TEST(tep != NULL);
> +	if (!tep)
> +		return;
> +
> +	trace_seq_init(&seq);
> +
> +	CU_TEST(tep_parse_kallsyms(tep, symbol_kallsyms) == 0);
> +	CU_TEST(tep_find_function(tep, 0x2000) == NULL);
> +	CU_TEST(tep_parse_format(tep, &event, jiffies_arith_event,
> +				 strlen(jiffies_arith_event),
> +				 "symbol") == TEP_ERRNO__SUCCESS);
> +
> +	trace_seq_reset(&seq);
> +	tep_print_event(tep, &seq, &record, "%s", TEP_PRINT_INFO);
> +	trace_seq_do_printf(&seq);
> +	CU_TEST(strcmp(seq.buffer, JIFFIES_ARITH_FMT) == 0);
> +
> +	trace_seq_destroy(&seq);
> +	tep_free(tep);
> +}
> +
>  static void test_btf_read(void)
>  {
>  	unsigned long args[] = {0x7ffe7d33f3d0, 0, 0, 0, 0, 0};
> @@ -466,6 +608,10 @@ void test_traceevent_lib(void)
>  		    test_parse_sizeof4);
>  	CU_add_test(suite, "parse sizeof() no long size defined",
>  		    test_parse_sizeof_undef);
> +	CU_add_test(suite, "parse _stext symbol arithmetic",
> +		    test_parse_symbol_offset);
> +	CU_add_test(suite, "reject data symbol arithmetic",
> +		    test_parse_jiffies_arith_invalid);
>  	CU_add_test(suite, "read BTF",
>  		    test_btf_read);
>  }

