Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63ECC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A5760FA0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhHKPuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 11:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhHKPuu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 11:50:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFFF60E97;
        Wed, 11 Aug 2021 15:50:26 +0000 (UTC)
Date:   Wed, 11 Aug 2021 11:50:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/5] libtraceevent: Add dynamic_offset()
Message-ID: <20210811115024.7a8220a6@oasis.local.home>
In-Reply-To: <20210811121203.29123-2-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
        <20210811121203.29123-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Aug 2021 15:11:59 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> @@ -4060,27 +4083,14 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
>  		}
>  		break;
>  	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
> -		offset = tep_read_number(tep,
> -					 data + arg->dynarray.field->offset,
> -					 arg->dynarray.field->size);
> -		/*
> -		 * The total allocated length of the dynamic array is
> -		 * stored in the top half of the field, and the offset
> -		 * is in the bottom half of the 32 bit field.
> -		 */
> -		val = (unsigned long long)(offset >> 16);
> +		dynamic_offset_field(tep, arg->dynarray.field, data,
> +				     NULL, &field_size);
> +		val = (unsigned long long) field_size;

The typecast is not needed: val = field_size; is good enough.

>  		break;
>  	case TEP_PRINT_DYNAMIC_ARRAY:
>  		/* Without [], we pass the address to the dynamic data */
> -		offset = tep_read_number(tep,
> -					 data + arg->dynarray.field->offset,
> -					 arg->dynarray.field->size);
> -		/*
> -		 * The total allocated length of the dynamic array is
> -		 * stored in the top half of the field, and the offset
> -		 * is in the bottom half of the 32 bit field.
> -		 */
> -		offset &= 0xffff;
> +		dynamic_offset_field(tep, arg->dynarray.field, data,
> +				     &offset, NULL);
>  		val = (unsigned long long)((unsigned long)data + offset);

Same here: val = (unsigned long)data + offset;

>  		break;
>  	default: /* not sure what to do there */
> @@ -4209,12 +4219,13 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  	struct tep_print_flag_sym *flag;
>  	struct tep_format_field *field;
>  	struct printk_map *printk;
> +	unsigned int offset, len;
>  	long long val, fval;
>  	unsigned long long addr;
>  	char *str;
>  	unsigned char *hex;
>  	int print;
> -	int i, len;
> +	int i;
>  
>  	switch (arg->type) {
>  	case TEP_PRINT_NULL:
> @@ -4318,11 +4329,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  	case TEP_PRINT_HEX:
>  	case TEP_PRINT_HEX_STR:
>  		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
> -			unsigned long offset;
> -			offset = tep_read_number(tep,
> -				data + arg->hex.field->dynarray.field->offset,
> -				arg->hex.field->dynarray.field->size);
> -			hex = data + (offset & 0xffff);
> +			dynamic_offset_field(tep, arg->hex.field->dynarray.field, data,
> +				             &offset, NULL);

The above is a nice cleanup!

> +			hex = data + offset;
>  		} else {
>  			field = arg->hex.field->field.field;
>  			if (!field) {
> @@ -4347,13 +4356,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  		int el_size;
>  
>  		if (arg->int_array.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
> -			unsigned long offset;
> -			struct tep_format_field *field =
> -				arg->int_array.field->dynarray.field;
> -			offset = tep_read_number(tep,
> -						 data + field->offset,
> -						 field->size);
> -			num = data + (offset & 0xffff);
> +			dynamic_offset_field(tep, arg->int_array.field->dynarray.field, data,
> +					     &offset, NULL);
> +			num = data + offset;
>  		} else {
>  			field = arg->int_array.field->field.field;
>  			if (!field) {
> @@ -4393,42 +4398,33 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  	case TEP_PRINT_TYPE:
>  		break;
>  	case TEP_PRINT_STRING: {
> -		int str_offset;
> -		int len;
> -
>  		if (arg->string.offset == -1) {
>  			struct tep_format_field *f;
>  
>  			f = tep_find_any_field(event, arg->string.string);
>  			arg->string.offset = f->offset;
>  		}
> -		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
> -		len = (str_offset >> 16) & 0xffff;
> +		dynamic_offset(tep, 4, data + arg->string.offset, &offset, &len);
>  		/* Do not attempt to save zero length dynamic strings */
>  		if (!len)
>  			break;
> -		str_offset &= 0xffff;
> -		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
> +		offset &= TEP_OFFSET_LEN_MASK;

Isn't the above redundant? Doesn't the dynamic_offset() do the masking?

> +		print_str_to_seq(s, format, len_arg, ((char *)data) + offset);
>  		break;
>  	}
>  	case TEP_PRINT_BSTRING:
>  		print_str_to_seq(s, format, len_arg, arg->string.string);
>  		break;
>  	case TEP_PRINT_BITMASK: {
> -		int bitmask_offset;
> -		int bitmask_size;
> -
>  		if (arg->bitmask.offset == -1) {
>  			struct tep_format_field *f;
>  
>  			f = tep_find_any_field(event, arg->bitmask.bitmask);
>  			arg->bitmask.offset = f->offset;
>  		}
> -		bitmask_offset = data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
> -		bitmask_size = bitmask_offset >> 16;
> -		bitmask_offset &= 0xffff;
> +		dynamic_offset(tep, 4, data + arg->bitmask.offset, &offset, &len);
>  		print_bitmask_to_seq(tep, s, format, len_arg,
> -				     data + bitmask_offset, bitmask_size);
> +				     data + offset, len);
>  		break;
>  	}
>  	case TEP_PRINT_OP:
> @@ -5271,13 +5267,12 @@ static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
>  			      void *data, int size, struct tep_event *event,
>  			      struct tep_print_arg *arg, int print_len)
>  {
> +	unsigned int offset, arr_len;
>  	int plen = print_len;
>  	char *delim = " ";
>  	int ret = 0;
>  	char *buf;
>  	int i;
> -	unsigned long offset;
> -	int arr_len;
>  
>  	switch (*(ptr + 1)) {
>  	case 'C':
> @@ -5304,11 +5299,9 @@ static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
>  		return ret;
>  	}
>  
> -	offset = tep_read_number(event->tep,
> -				 data + arg->dynarray.field->offset,
> -				 arg->dynarray.field->size);
> -	arr_len = (unsigned long long)(offset >> 16);
> -	buf = data + (offset & 0xffff);
> +	dynamic_offset_field(event->tep, arg->dynarray.field, data,
> +			     &offset, &arr_len);
> +	buf = data + offset;
>  
>  	if (arr_len < plen)
>  		plen = arr_len;
> @@ -5336,19 +5329,18 @@ static int is_printable_array(char *p, unsigned int len)
>  void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field)
>  {
> -	unsigned long long val;
> -	unsigned int offset, len, i;
>  	struct tep_handle *tep = field->event->tep;
> +	unsigned int offset, len, i;
> +	unsigned long long val;
>  
>  	if (field->flags & TEP_FIELD_IS_ARRAY) {
> -		offset = field->offset;
> -		len = field->size;
>  		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
> -			val = tep_read_number(tep, data + offset, len);
> -			offset = val;
> -			len = offset >> 16;
> -			offset &= 0xffff;
> +			dynamic_offset_field(tep, field, data, &offset, &len);
> +		} else {
> +			offset = field->offset;
> +			len = field->size;
>  		}
> +

No need to add this blank line. The rest of the function doesn't have
them, so I would keep it consistent and not add one.

But the rest looks good.

-- Steve


>  		if (field->flags & TEP_FIELD_IS_STRING &&
>  		    is_printable_array(data + offset, len)) {
>  			trace_seq_printf(s, "%s", (char *)data + offset);

