Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808A1C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51687214D8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfCLT2W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfCLT2V (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 15:28:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D80214AF;
        Tue, 12 Mar 2019 19:28:20 +0000 (UTC)
Date:   Tue, 12 Mar 2019 15:28:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v8 13/13] trace-cmd: Add VM tracing over FIFOs
 transport
Message-ID: <20190312152819.3eae7941@gandalf.local.home>
In-Reply-To: <20190222180539.27439-14-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
        <20190222180539.27439-14-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Feb 2019 20:05:39 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> FIFOs offer ~3x the throughput of vsockets. This patch adds support for using
> FIFOs to stream tracing data back to the host when tracing VMs.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h  |  8 ++--
>  tracecmd/include/trace-local.h |  4 +-
>  tracecmd/trace-agent.c         | 40 ++++++++++++++--
>  tracecmd/trace-msg.c           | 26 ++++++----
>  tracecmd/trace-record.c        | 87 ++++++++++++++++++++++++++++++----
>  5 files changed, 137 insertions(+), 28 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 52962e9..27ba89d 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -333,16 +333,16 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
>  void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
>  
>  int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
> -				int argc, char **argv);
> +				int argc, char **argv, bool use_fifos);
>  int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
> -				int *argc, char ***argv);
> +				int *argc, char ***argv, bool *use_fifos);
>  
>  int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int nr_cpus, int page_size,
> -				 unsigned int *ports);
> +				 unsigned int *ports, bool use_fifos);
>  int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int *nr_cpus, int *page_size,
> -				 unsigned int **ports);
> +				 unsigned int **ports, bool *use_fifos);

Hmm, maybe flags would be good to keep. We can put "use_fifos" in the
flags field of the ports being passed across.

-- Steve

>  
>  /* --- Plugin handling --- */
>  extern struct tep_plugin_option trace_ftrace_options[];
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index d32ba88..d7bdb1f 100644

