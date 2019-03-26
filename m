Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1615CC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E564B2084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfCZNMP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbfCZNMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:12:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC63F20823;
        Tue, 26 Mar 2019 13:12:13 +0000 (UTC)
Date:   Tue, 26 Mar 2019 09:12:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] tools/lib/traceevent: Change description of few
 APIs
Message-ID: <20190326091212.4e7581b0@gandalf.local.home>
In-Reply-To: <20190325145017.30246-2-tstoyanov@vmware.com>
References: <20190325145017.30246-1-tstoyanov@vmware.com>
        <20190325145017.30246-2-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Mar 2019 16:50:15 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> APIs descriptions should describe the purpose of the
> function, its parameters and return value. While working
> on man pages implementation, I noticed mismatches in the
> descriptions of few APIs. This patch changes the description
> of these APIs, making them consistent with the man pages:
> tep_print_num_field(), tep_print_func_field(),
> tep_get_header_page_size(), tep_get_long_size(),
> tep_set_long_size(), tep_get_page_size() and
> tep_set_page_size().

Hi Tzvetomir,

The above is very hard to read. Please list them one per line, and
write it like this:

 APIs descriptions should describe the purpose of the function, its
 parameters and return value. While working  on man pages
 implementation, I noticed mismatches in the  descriptions of few APIs.
 This patch changes the description of these APIs, making them
 consistent with the man pages:

 - tep_print_num_field()
 - tep_print_func_field()
 - tep_get_header_page_size()
 - tep_get_long_size()
 - tep_set_long_size()
 - tep_get_page_size()
 - tep_set_page_size()


It's much easier on the eyes.

I changed it for you. But next time, please start listing functions
instead of stringing them in one hard to read bundle.

Thanks!

-- Steve



> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-api.c | 20 ++++++++++----------
>  tools/lib/traceevent/event-parse.c     |  6 ++++--
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> index d463761a58f4..3686a221e981 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -43,8 +43,8 @@ int tep_get_events_count(struct tep_handle *tep)
>   * @flag: flag, or combination of flags to be set
>   * can be any combination from enum tep_flag
>   *
> - * This sets a flag or mbination of flags  from enum tep_flag
> -  */
> + * This sets a flag or combination of flags from enum tep_flag
> + */
>  void tep_set_flag(struct tep_handle *tep, int flag)
>  {
>  	if(tep)
> @@ -140,10 +140,10 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
>  }
>  
>  /**
> - * tep_get_long_size - get the size of a long integer on the current machine
> + * tep_get_long_size - get the size of a long integer on the traced machine
>   * @pevent: a handle to the tep_handle
>   *
> - * This returns the size of a long integer on the current machine
> + * This returns the size of a long integer on the traced machine
>   * If @pevent is NULL, 0 is returned.
>   */
>  int tep_get_long_size(struct tep_handle *pevent)
> @@ -154,11 +154,11 @@ int tep_get_long_size(struct tep_handle *pevent)
>  }
>  
>  /**
> - * tep_set_long_size - set the size of a long integer on the current machine
> + * tep_set_long_size - set the size of a long integer on the traced machine
>   * @pevent: a handle to the tep_handle
>   * @size: size, in bytes, of a long integer
>   *
> - * This sets the size of a long integer on the current machine
> + * This sets the size of a long integer on the traced machine
>   */
>  void tep_set_long_size(struct tep_handle *pevent, int long_size)
>  {
> @@ -167,10 +167,10 @@ void tep_set_long_size(struct tep_handle *pevent, int long_size)
>  }
>  
>  /**
> - * tep_get_page_size - get the size of a memory page on the current machine
> + * tep_get_page_size - get the size of a memory page on the traced machine
>   * @pevent: a handle to the tep_handle
>   *
> - * This returns the size of a memory page on the current machine
> + * This returns the size of a memory page on the traced machine
>   * If @pevent is NULL, 0 is returned.
>   */
>  int tep_get_page_size(struct tep_handle *pevent)
> @@ -181,11 +181,11 @@ int tep_get_page_size(struct tep_handle *pevent)
>  }
>  
>  /**
> - * tep_set_page_size - set the size of a memory page on the current machine
> + * tep_set_page_size - set the size of a memory page on the traced machine
>   * @pevent: a handle to the tep_handle
>   * @_page_size: size of a memory page, in bytes
>   *
> - * This sets the size of a memory page on the current machine
> + * This sets the size of a memory page on the traced machine
>   */
>  void tep_set_page_size(struct tep_handle *pevent, int _page_size)
>  {
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 87494c7c619d..e53c566be55d 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -6386,7 +6386,8 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
>   * @record: The record with the field name.
>   * @err: print default error if failed.
>   *
> - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> + * Returns positive value on success, negative in case of an error,
> + * or 0 if buffer is full.
>   */
>  int tep_print_num_field(struct trace_seq *s, const char *fmt,
>  			struct tep_event *event, const char *name,
> @@ -6418,7 +6419,8 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
>   * @record: The record with the field name.
>   * @err: print default error if failed.
>   *
> - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> + * Returns positive value on success, negative in case of an error,
> + * or 0 if buffer is full.
>   */
>  int tep_print_func_field(struct trace_seq *s, const char *fmt,
>  			 struct tep_event *event, const char *name,

