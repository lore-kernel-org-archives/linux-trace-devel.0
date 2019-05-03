Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E321BC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0B221479
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfECQRL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 12:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfECQRL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 12:17:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8920B2075E;
        Fri,  3 May 2019 16:17:10 +0000 (UTC)
Date:   Fri, 3 May 2019 12:17:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Kacur <jkacur@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] trace-cmd-listen: Fix resource leak of msg_handle
Message-ID: <20190503121708.711bef39@gandalf.local.home>
In-Reply-To: <20190503142449.9936-1-jkacur@redhat.com>
References: <20190503142449.9936-1-jkacur@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  3 May 2019 16:24:49 +0200
John Kacur <jkacur@redhat.com> wrote:

> Fix the potential resource leak of msg_handle by calling
> tracecmd_msg_handle_close before returning in an error path
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  tracecmd/trace-listen.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 8bd7badb50e1..3106022eeb39 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -761,6 +761,7 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
>  		plog("Error with getnameinfo: %s\n",
>  		       gai_strerror(s));
>  		close(cfd);
> +		tracecmd_msg_handle_close(msg_handle);
>  		return -1;
>  	}
>  

Applied. Thanks John!

-- Steve
