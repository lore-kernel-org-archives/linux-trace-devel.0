Return-Path: <SRS0=Ov7o=QM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2893AC282CB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Feb 2019 15:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A1E217F9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Feb 2019 15:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfBEPOw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Feb 2019 10:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfBEPOw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Feb 2019 10:14:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A8C20811;
        Tue,  5 Feb 2019 15:14:51 +0000 (UTC)
Date:   Tue, 5 Feb 2019 10:14:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: Re: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return
 error code if any
Message-ID: <20190205101449.6d7ed6d2@gandalf.local.home>
In-Reply-To: <20190204070855.8921-7-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
        <20190204070855.8921-7-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 Feb 2019 09:08:53 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

I accepted your patches up to here with some slight modifications to
the subjects and change logs. Note, when referencing function names,
its mostly desirable to add a "()" to the end of them to make it stand
out that they are functions. Like tracecmd_msg_send_close().

But, this patch needs a change log to explain why this function should
return an error code. Is something going to rely on it in the future?

-- Steve



> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h | 2 +-
>  tracecmd/trace-msg.c          | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 33f352b..0ab23f6 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -318,7 +318,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
>  int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
>  			       const char *buf, int size);
>  int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
> -void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
> +int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
>  
>  /* for server */
>  int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
> diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
> index b4b58d4..c24424b 100644
> --- a/tracecmd/trace-msg.c
> +++ b/tracecmd/trace-msg.c
> @@ -549,12 +549,12 @@ int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
>  	return 0;
>  }
>  
> -void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
> +int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
>  {
>  	struct tracecmd_msg msg;
>  
>  	tracecmd_msg_init(MSG_CLOSE, &msg);
> -	tracecmd_msg_send(msg_handle->fd, &msg);
> +	return tracecmd_msg_send(msg_handle->fd, &msg);
>  }
>  
>  int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,

