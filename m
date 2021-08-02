Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE5CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8F260FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhHBLjZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhHBLjY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:39:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66C1C06175F
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 Aug 2021 04:39:14 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m19so10226298wms.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Aug 2021 04:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IiPDo6XpjfG9EJ6sW7nTOTm42BrY7NhCeWtbR/Om4Nk=;
        b=t5KOt+nmdkvlL47DVMznqO+k+8UUq/SqdVv0RTMweexTNsXqC49yCeCsk8IBENtew6
         STDxCgAotpUiDIICmEgEUuEPEDOVc3Kkup0wBzoiT7EHRUGLpVGRtcKQknHMB1mhhBBR
         Ly9L7l1yaZltTmLHYgU0vrzO2KYLa50Prd6f65VJvEN7N4a75rXctFtjxFmG7gTm4Ovw
         wY9MQGjNGJlfCrOC/pAcXcWM2Wh+t2Tnq+ccI4rXHIredA3/codnQCLCKNJb3ztqUTKC
         DrTDFnalagH0pXQ7tPgP7meQQZcXniQKyM5F02btHj7Hm8eKMy0/2CnfLO7Y+YkXFby4
         azTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IiPDo6XpjfG9EJ6sW7nTOTm42BrY7NhCeWtbR/Om4Nk=;
        b=iT3acusUS3C4S4wqrKwNRsBwPLLert8NnzarUjot99sXO2vs9SK3dmbYu7JMw1b3Z5
         1zzXgByhny0jWLHghgAmK1r2/TRs+hdWeQXg/1j17z2rNwfmbo5HngkGRoV8dqKADmCj
         HkJDm90OiNv8wi0UHDqYSIff1lmX2jaaPItbuS5xwKxQTFWmF7kHZ7lEXIXejmzXv1pB
         svbEntFRKSI8vwxhA/Y88O1wpDe6vYNNmN/GXKO94l9XKwxk4VkfKQTZRxkN4guAZV03
         CzWk+qY6C+Kvj9pLdTIoQN2QXyq8jwePAFP5LJYzr0hGRMnL09bPcyAS6HiuhpWISRUQ
         zdYw==
X-Gm-Message-State: AOAM531/HYuIMT2y6lFbrhdWPjalezdVKmo9tUQiUZqq0ZhRSIQpfUWB
        uVQxTskLDEBQEQDQnvtH0wtHBvLH0UU=
X-Google-Smtp-Source: ABdhPJyKJ2l7hgg2b9vWGJi+A4SJeFtEJAV5yvx5bgoss0P5RVdzuObWyAknACJgUxaEgo0C0fXZ1w==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr16091283wmh.151.1627904353111;
        Mon, 02 Aug 2021 04:39:13 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id e3sm11055780wrw.51.2021.08.02.04.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 04:39:12 -0700 (PDT)
Subject: Re: [RFC PATCH] libtraceevent: Add tep_print_selected_fields()
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20210802112714.67631-1-y.karadz@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <0f00d3ec-57a1-8cdf-1ecd-fc6910204f1e@gmail.com>
Date:   Mon, 2 Aug 2021 14:39:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802112714.67631-1-y.karadz@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven,

The implementation of static void tep_print_fmt_field() is incomplete.
If you compare the logic there with the implementation of
void tep_print_field() you will see that I am not handling the case of
a field that is an "ARRAY".

Any ideas what is the best way to handle this case?

Thanks!
Yordan


On 2.08.21 г. 14:27, Yordan Karadzhov (VMware) wrote:
> The new method can print only a subset of the unique data fields of
> the trace event. The print format is derived from the parsing tokens
> (tep_print_parse objects) of the event. As a byproduct of this change
> the existing method tep_print_fields() gets upgraded to use the
> formats provided by the tokens.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>   src/event-parse.c | 87 ++++++++++++++++++++++++++++++++++++++++++-----
>   src/event-parse.h |  3 ++
>   2 files changed, 81 insertions(+), 9 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index f42ae38..7302f3d 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -3585,6 +3585,8 @@ tep_find_field(struct tep_event *event, const char *name)
>   	return format;
>   }
>   
> +
> +
>   /**
>    * tep_find_any_field - find any field by name
>    * @event: handle for the event
> @@ -5333,6 +5335,19 @@ static int is_printable_array(char *p, unsigned int len)
>   	return 1;
>   }
>   
> +static void dynamic_offset(struct tep_handle *tep,
> +			   struct tep_format_field *field,
> +			   void *data,
> +			   unsigned int *offset,
> +			   unsigned int *len)
> +{
> +	unsigned long long val;
> +
> +	val = tep_read_number(tep, data + field->offset, field->size);
> +	*offset = val & SHRT_MAX;
> +	*len = val >> 16;
> +}
> +
>   void tep_print_field(struct trace_seq *s, void *data,
>   		     struct tep_format_field *field)
>   {
> @@ -5343,12 +5358,9 @@ void tep_print_field(struct trace_seq *s, void *data,
>   	if (field->flags & TEP_FIELD_IS_ARRAY) {
>   		offset = field->offset;
>   		len = field->size;
> -		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
> -			val = tep_read_number(tep, data + offset, len);
> -			offset = val;
> -			len = offset >> 16;
> -			offset &= 0xffff;
> -		}
> +		if (field->flags & TEP_FIELD_IS_DYNAMIC)
> +			dynamic_offset(tep, field, data, &offset, &len);
> +
>   		if (field->flags & TEP_FIELD_IS_STRING &&
>   		    is_printable_array(data + offset, len)) {
>   			trace_seq_printf(s, "%s", (char *)data + offset);
> @@ -5398,19 +5410,76 @@ void tep_print_field(struct trace_seq *s, void *data,
>   	}
>   }
>   
> -void tep_print_fields(struct trace_seq *s, void *data,
> -		      int size __maybe_unused, struct tep_event *event)
> +static struct tep_print_parse *parse_format_next(struct tep_print_parse *parse)
> +{
> +	while (parse) {
> +		if (strncmp(parse->format, "%", 1) == 0)
> +			break;
> +
> +		parse = parse->next;
> +	}
> +
> +	return parse;
> +}
> +
> +static void tep_print_fmt_field(struct trace_seq *s, void *data,
> +				const char *format,
> +				struct tep_format_field *field)
> +{
> +	struct tep_handle *tep = field->event->tep;
> +	unsigned int len, offset;
> +	unsigned long long val;
> +
> +	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
> +		dynamic_offset(tep, field, data, &offset, &len);
> +		if (len)
> +			trace_seq_printf(s, format, (char *)data + offset);
> +		else
> +			trace_seq_printf(s, format, "(nil)");
> +	} else {
> +		val = tep_read_number(tep, data + field->offset, field->size);
> +		trace_seq_printf(s, format, val);
> +	}
> +}
> +
> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> +			       struct tep_event *event,
> +			       int ignore_mask)
>   {
>   	struct tep_format_field *field;
> +	struct tep_print_parse *parse;
> +	unsigned int len;
> +	int field_mask = 1;
>   
> +	parse = event->print_fmt.print_cache;
>   	field = event->format.fields;
>   	while (field) {
> +		parse = parse_format_next(parse);
> +
> +		if (field_mask & ignore_mask)
> +			goto next;
> +
>   		trace_seq_printf(s, " %s=", field->name);
> -		tep_print_field(s, data, field);
> +
> +		len = strlen(parse->format);
> +		if (len > 0 && parse->format[len - 1] == 'x')
> +			trace_seq_printf(s, "0x");
> +
> +		tep_print_fmt_field(s, data, parse->format, field);
> +
> + next:
>   		field = field->next;
> +		parse = parse->next;
> +		field_mask *= 2;
>   	}
>   }
>   
> +void tep_print_fields(struct trace_seq *s, void *data,
> +		      int size __maybe_unused, struct tep_event *event)
> +{
> +	tep_print_selected_fields(s, data, event, 0);
> +}
> +
>   static int print_function(struct trace_seq *s, const char *format,
>   			  void *data, int size, struct tep_event *event,
>   			  struct tep_print_arg *arg)
> diff --git a/src/event-parse.h b/src/event-parse.h
> index d4a876f..fe0fbf4 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -547,6 +547,9 @@ void tep_print_field(struct trace_seq *s, void *data,
>   		     struct tep_format_field *field);
>   void tep_print_fields(struct trace_seq *s, void *data,
>   		      int size __maybe_unused, struct tep_event *event);
> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> +			       struct tep_event *event,
> +			       int ignore_mask);
>   int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
>   		 char *buf, size_t buflen);
>   
> 
