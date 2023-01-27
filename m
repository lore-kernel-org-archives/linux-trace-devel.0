Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE32C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Jan 2023 19:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjA0T5a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 27 Jan 2023 14:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjA0T5F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 27 Jan 2023 14:57:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805448BBB5;
        Fri, 27 Jan 2023 11:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0C6FB807E4;
        Fri, 27 Jan 2023 19:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F166C433D2;
        Fri, 27 Jan 2023 19:54:00 +0000 (UTC)
Date:   Fri, 27 Jan 2023 14:53:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 30/35] Documentation: tools/rtla: correct spelling
Message-ID: <20230127145358.2c7612a1@gandalf.local.home>
In-Reply-To: <20230127064005.1558-31-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
        <20230127064005.1558-31-rdunlap@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 26 Jan 2023 22:40:00 -0800
Randy Dunlap <rdunlap@infradead.org> wrote:

> Correct spelling problems for Documentation/tools/rtla/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: linux-trace-devel@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> ---

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

>  Documentation/tools/rtla/rtla-timerlat-top.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -- a/Documentation/tools/rtla/rtla-timerlat-top.rst b/Documentation/tools/rtla/rtla-timerlat-top.rst
> --- a/Documentation/tools/rtla/rtla-timerlat-top.rst
> +++ b/Documentation/tools/rtla/rtla-timerlat-top.rst
> @@ -128,7 +128,7 @@ and then when the *timerlat* thread was
>  then be used as the starting point of a more fine-grained analysis.
>  
>  Note that **rtla timerlat** was dispatched without changing *timerlat* tracer
> -threads' priority. That is generally not needed because these threads hava
> +threads' priority. That is generally not needed because these threads have
>  priority *FIFO:95* by default, which is a common priority used by real-time
>  kernel developers to analyze scheduling delays.
>  

