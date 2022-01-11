Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A59EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 00:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbiAKAhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 19:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345546AbiAKAhj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 19:37:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EBBC06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 16:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EAAB614D2
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CC5C36AE5;
        Tue, 11 Jan 2022 00:37:38 +0000 (UTC)
Date:   Mon, 10 Jan 2022 19:37:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 0/2] libtraceevent: Allow %pIS to work with dynamic
 arrays
Message-ID: <20220110193737.22836a2d@gandalf.local.home>
In-Reply-To: <20220111001705.692692-1-rostedt@goodmis.org>
References: <20220111001705.692692-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Chuck,

I forgot to add you to the Cc of the series, but you can download it from
here:

  https://patchwork.kernel.org/series/604304/mbox/

-- Steve


On Mon, 10 Jan 2022 19:17:03 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Chuck Lever reported that adding the following:
> 
> #define field_sockaddr(field, len)  __dynamic_array(u8, field, len)
> #define assign_sockaddr(dest, src, len)  memcpy(__get_dynamic_array(dest), src, len)
> #define __get_sockaddr(field)  ((struct sockaddr *)__get_dynamic_array(field))
> 
> TRACE_EVENT(sockaddr_example,
>         TP_PROTO(
>                 const struct sockaddr *sap,
>                 size_t salen
>         ),  
>         TP_ARGS(sap, salen),
>         TP_STRUCT__entry(
>                 __field_sockaddr(addr, salen)
>         ),  
>         TP_fast_assign(
>                 __assign_sockaddr(addr, sap, salen);
>         ),  
>         TP_printk("addr=%pIS", __get_sockaddr(addr))
> );
> 
> Causes trace-cmd to report:
> 
>   "addr=ARG TYPE NOT FIELD BUT 7"
> 
> Which is not only unwanted, but rather unhelpful.
> 
> Fix it to allow %pIS to work with dynamic arrays, and also allow all fields to
> still work if they are typecasted.
> 
> Link: https://lore.kernel.org/all/164182978641.8391.8277203495236105391.stgit@bazille.1015granger.net/
> 
> Steven Rostedt (2):
>   libtraceevent: Do not fail field parsing if field has typecast
>   libtraceevent: Allow ipsa arg to use dynamic arrays
> 
>  src/event-parse.c | 70 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 54 insertions(+), 16 deletions(-)
> 

