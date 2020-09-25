Return-Path: <SRS0=kVK7=DC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E17C4363D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Sep 2020 14:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B3020936
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Sep 2020 14:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgIYOR2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgIYOR2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 10:17:28 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF163208A9;
        Fri, 25 Sep 2020 14:17:26 +0000 (UTC)
Date:   Fri, 25 Sep 2020 10:17:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tools lib traceevent: Hide non API functions
Message-ID: <20200925101724.64e55c61@oasis.local.home>
In-Reply-To: <20200924070609.100771-2-tz.stoyanov@gmail.com>
References: <20200924070609.100771-1-tz.stoyanov@gmail.com>
        <20200924070609.100771-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Sep 2020 10:06:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are internal library functions, which are not decalred as a static.
> They are used inside the library from different files. Hide them from
> the library users, as they are not part of the API.
> These functions are made hidden and are renamed without the prefix "tep_":
>  tep_free_plugin_paths
>  tep_peek_char
>  tep_buffer_init
>  tep_get_input_buf_ptr
>  tep_get_input_buf
>  tep_read_token
>  tep_free_token
>  tep_free_event
>  tep_free_format_field

You have tep_free_plugin_paths twice.

>  tep_free_plugin_paths
> 
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tools/lib/traceevent/event-parse-api.c   |  8 +--
>  tools/lib/traceevent/event-parse-local.h | 24 +++++--
>  tools/lib/traceevent/event-parse.c       | 88 ++++++------------------
>  tools/lib/traceevent/event-parse.h       |  8 ---
>  tools/lib/traceevent/event-plugin.c      |  2 +-
>  tools/lib/traceevent/parse-filter.c      | 23 +++----
>  6 files changed, 52 insertions(+), 101 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> index 4faf52a65791..23c4a00ae45b 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -92,7 +92,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
>  	return false;
>  }
>  
> -unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
> +__hidden unsigned short _data2host2(struct tep_handle *tep, unsigned short data)
>  {
>  	unsigned short swap;
>  
> @@ -105,7 +105,7 @@ unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
>  	return swap;
>  }
>  
> -unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
> +__hidden unsigned int _data2host4(struct tep_handle *tep, unsigned int data)

As these are hidden, we don't need the leading underscore. Thus
data2host2 and data2host4, etc, is fine.

>  {
>  	unsigned int swap;
>  
> @@ -120,8 +120,8 @@ unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
>  	return swap;
>  }
>  
> -unsigned long long
> -tep_data2host8(struct tep_handle *tep, unsigned long long data)
> +__hidden  unsigned long long
> +_data2host8(struct tep_handle *tep, unsigned long long data)
>  {
>  	unsigned long long swap;
>  
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index d805a920af6f..d9417437679a 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -15,6 +15,8 @@ struct event_handler;
>  struct func_resolver;
>  struct tep_plugins_dir;
>  
> +#define __hidden __attribute__((visibility ("hidden")))
> +
>  struct tep_handle {
>  	int ref_count;
>  
> @@ -102,12 +104,20 @@ struct tep_print_parse {
>  	struct tep_print_arg		*len_as_arg;
>  };
>  
> -void tep_free_event(struct tep_event *event);
> -void tep_free_format_field(struct tep_format_field *field);
> -void tep_free_plugin_paths(struct tep_handle *tep);
> -
> -unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
> -unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
> -unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
> +void free_tep_event(struct tep_event *event);
> +void free_tep_format_field(struct tep_format_field *field);
> +void free_tep_plugin_paths(struct tep_handle *tep);
> +
> +unsigned short _data2host2(struct tep_handle *tep, unsigned short data);
> +unsigned int _data2host4(struct tep_handle *tep, unsigned int data);
> +unsigned long long _data2host8(struct tep_handle *tep, unsigned long long data);
> +
> +/* access to the internal parser */
> +int __peek_char(void);

Same for __peek_char(). We can call it peek_char().

Other than that, I think this looks good.

When sending the next version, I would send it to Arnaldo directly and
Cc this list, LKML, and myself. Then I'll just ack it for Arnaldo to
take it directly from you.

Add v2 in the subject '[PATCH v2]' and state the differences of v1
after the '---' of your signed off by. You could also add,

 V1 found here: https://lore.kernel.org/r/20200924070609.100771-2-tz.stoyanov@gmail.com

so that Arnaldo knows where to find v1, as I don't think he's on this
list.

Thanks!

-- Steve
