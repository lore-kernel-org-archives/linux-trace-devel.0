Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EF9C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 12:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD97E60F92
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 12:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhHCMmS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 08:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbhHCMmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 08:42:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BACC061757
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Aug 2021 05:42:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c9so4898100wri.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Aug 2021 05:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+vllGGn7+Q2qsJ66Lt/w9zoI/oCCSo0J6DhNkvpANi4=;
        b=h/59amP04RSv2InU5D9zfrSVCPgseW78XJJxQldMnV+ZEJirkQQhvjImlxUW7Ed5+w
         V8drVAXBinTpmmnc0r7Humsg87V3MIUJo0Hp4S3fZKF+kPQMlvofE3VT5D0QTJuAfjle
         q6qOxnnhGuAo/PlA4DEouQbxto1BrXBHqFf3ZA7lgpHKIfwZDHys8DVkQtQBU4Ob0p4f
         GoCndKR3BqVQW4wLoGVmqcSCWs/wf+xu1VTZIQZO5BJ+wRjD9j6BcoXz1AaMD8C7KJHW
         3wC20tPACqZesupwx6kuBVYfzFmz7/cGwipfO89gNg7ihl8XkB4XWd+GcHLWdxG/N37j
         2k9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+vllGGn7+Q2qsJ66Lt/w9zoI/oCCSo0J6DhNkvpANi4=;
        b=m/Tx5+QKwCcLDnDFLDbPLY45/uGs7h4STqD3jLm/T8w+U+cLj8Ki7T7YAOopdPH36x
         d7vkvAJ6F4ggmg5VGKT8eDnkxwgBpzr+vb6eGmbnlrfQ6LVDpDkJsyqu8eHeemfthhv+
         XG4mmj76oefQp/QBfbBNSpVT44nFq85VfoOkCt9XRF/K9EwZWs7jmw5btVvbrf61MJrF
         E9K9ETogObG2egVAkJG38FgGqAcdfn8bq+OPZiFn+wYdlc2HZMkbNtJAiiBVlhI3MvCe
         lY3B7kH5XD7ihl70kXTc2khaZjvq0YnFkn/eOX2PKxdfkBKCBQT9pbQ8PvVuf5JXv0J0
         uf7A==
X-Gm-Message-State: AOAM531vCoMu9qfrSr8wP21Hlp8tPRZ8paEHBBp5NpmybVf06C+Psln9
        38qWhEtW9LYxJC1wclAkdyZo7OA7syo=
X-Google-Smtp-Source: ABdhPJxS8vKnncnHxdCREDeqPGig3ddg+XuUh0C8kxgFk1v3jEEnqisCUvNlC0h6iNp1T6bYJj3snw==
X-Received: by 2002:adf:8169:: with SMTP id 96mr22455821wrm.424.1627994523471;
        Tue, 03 Aug 2021 05:42:03 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id a16sm14705253wrx.7.2021.08.03.05.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 05:42:03 -0700 (PDT)
Subject: Re: [RFC PATCH] libtraceevent: Add tep_print_selected_fields()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210802112714.67631-1-y.karadz@gmail.com>
 <20210802122933.1873b6f8@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <75f05e4c-49bb-a2d9-cdae-58d801e58179@gmail.com>
Date:   Tue, 3 Aug 2021 15:42:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802122933.1873b6f8@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.08.21 г. 19:29, Steven Rostedt wrote:
> What I was talking about is to change tep_print_field() to do something like:
> 
> Take the current tep_print_field() and turn it into static _tep_print_field().
> 
>   [ Not even compiled tested ]
> 

Hi Steven,

I am not able to make sense from the code below.

> void tep_print_field(struct trace_seq *s, void *data,
> 		     struct tep_format_field *field)
> {
> 	struct tep_event = field->event;
> 	struct tep_print_parse = event->print_fmt.print_cache;
> 	struct tep_handle *tep = event->tep;
> 	unsigned int offset, len;
> 
> 	if (event->flags & TEP_EVENT_FL_FAILED)
> 		goto out;
> 
> 	if (field->flags & TEP_FIELD_IS_DYNAMIC)
> 		dynamic_offset(tep, field, data, &offset, &len);
> 
> 	for (;parse; parse = parse->next) {

You need
         if (!parse->arg)
			continue;

> 		if (parse->type == PRINT_FMT_STRING)
> 			continue;
> 		if (parse->arg->type != TEP_PRINT_FIELD)
> 			continue;

I can't understand the idea of those two checks. I printed the values and they don't seem to have any selective power.

> 		if (parse->arg->field.field->field != field)
> 			continue;
> 

This does not compile. I guess you mean
  		if (parse->arg->field.field != field)
  			continue;

however "parse->arg->field.field" looks like unused memory (NULL or 0xffffffff) and this check always fails.

Maybe we must call some of the process_XXX()static functions first in order to make your new version of 
tep_print_field() works?

Thanks!
Yordan

> 		print_parse_data(parse, s, data, size, event);
> 		return;
> 	}
> 
>   out:
> 	/* Not found */
> 	
