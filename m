Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A31AC4727D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119D520774
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgI2VXd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 17:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729555AbgI2VXY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 17:23:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6606F2075E;
        Tue, 29 Sep 2020 21:23:22 +0000 (UTC)
Date:   Tue, 29 Sep 2020 17:23:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     arnaldo.melo@gmail.com, linux-trace-devel@vger.kernel.org,
        ben@decadent.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tools lib traceevent: Hide non API functions
Message-ID: <20200929172320.4adb4fc3@gandalf.local.home>
In-Reply-To: <20200929173521.251934-1-tz.stoyanov@gmail.com>
References: <20200929173521.251934-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 20:35:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are internal library functions, which are not declared as a static.
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

I would mention in the change log about the __tep_parse_format() being made
static.

> 
> Link: https://lore.kernel.org/linux-trace-devel/e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk/
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> v1 of the patch is here: https://lore.kernel.org/r/20200924070609.100771-2-tz.stoyanov@gmail.com
> v2 changes (addressed Steven's comments):
>   - Removed leading underscores from the names of newly hidden internal
>     functions.
> v3 changes (addressed Steven's comment):
>   - Moved comments from removed APIs to internal functions.
>   - Fixed a typo in patch description.
> 
>  tools/lib/traceevent/event-parse-api.c   |   8 +-
>  tools/lib/traceevent/event-parse-local.h |  24 +++--
>  tools/lib/traceevent/event-parse.c       | 125 ++++++++++-------------
>  tools/lib/traceevent/event-parse.h       |   8 --
>  tools/lib/traceevent/event-plugin.c      |   2 +-
>  tools/lib/traceevent/parse-filter.c      |  23 ++---
>  6 files changed, 83 insertions(+), 107 deletions(-)
> 

>  /**
> - * tep_peek_char - peek at the next character that will be read
> + * peek_char - peek at the next character that will be read
>   *
>   * Returns the next character read, or -1 if end of buffer.
>   */
> -int tep_peek_char(void)
> +__hidden  int peek_char(void)

Nit, but there's two spaces between "__hidden" and "int", should only be
one.

>  {
> -	return __peek_char();
> +	if (input_buf_ptr >= input_buf_siz)
> +		return -1;
> +
> +	return input_buf[input_buf_ptr];
>  }
>  

>  /**
> - * __tep_parse_format - parse the event format
> + * __parse_format - parse the event format
>   * @buf: the buffer storing the event format string
>   * @size: the size of @buf
>   * @sys: the system the event belongs to
> @@ -6762,9 +6741,9 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
>   *
>   * /sys/kernel/debug/tracing/events/.../.../format
>   */
> -enum tep_errno __tep_parse_format(struct tep_event **eventp,
> -				  struct tep_handle *tep, const char *buf,
> -				  unsigned long size, const char *sys)
> +static enum tep_errno __parse_format(struct tep_event **eventp,

Actually, we don't need the "__" prefix. Just call it "parse_format".


> +					   struct tep_handle *tep, const char *buf,
> +					   unsigned long size, const char *sys)
>  {
>  	struct tep_event *event;
>  	int ret;

> @@ -959,7 +954,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
>  
>  	do {
>  		free(token);
> -		type = read_token(&token);
> +		type = filter_read_token(&token);

Hmm, did you mean to change this from "read_token()" to
"filter_read_token()"?

-- Steve


>  		switch (type) {
>  		case TEP_EVENT_SQUOTE:
>  		case TEP_EVENT_DQUOTE:
> @@ -1185,7 +1180,7 @@ process_event(struct tep_event *event, const char *filter_str,
>  {
>  	int ret;
>  
> -	tep_buffer_init(filter_str, strlen(filter_str));
> +	init_input_buf(filter_str, strlen(filter_str));
>  
>  	ret = process_filter(event, parg, error_str, 0);
>  	if (ret < 0)
> @@ -1243,7 +1238,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
>  static void filter_init_error_buf(struct tep_event_filter *filter)
>  {
>  	/* clear buffer to reset show error */
> -	tep_buffer_init("", 0);
> +	init_input_buf("", 0);
>  	filter->error_buffer[0] = '\0';
>  }
>  

