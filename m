Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057BEC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 19:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEE1218D0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 19:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCOTIj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 15:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbfCOTIj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 15:08:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F762064A;
        Fri, 15 Mar 2019 19:08:38 +0000 (UTC)
Date:   Fri, 15 Mar 2019 15:08:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [PATCH 3/3] trace-cmd: Add msg_buf_len() function
Message-ID: <20190315150836.7e2bc4f3@gandalf.local.home>
In-Reply-To: <20190315153326.5602-4-kaslevs@vmware.com>
References: <20190315153326.5602-1-kaslevs@vmware.com>
        <20190315153326.5602-4-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 15 Mar 2019 17:33:26 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Factor out common code computing message buffer length in a function.
> 
> No changes in behavior intended.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  tracecmd/trace-msg.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
> index 48f1eac..a91b211 100644
> --- a/tracecmd/trace-msg.c
> +++ b/tracecmd/trace-msg.c
> @@ -107,6 +107,11 @@ struct tracecmd_msg {
>  	void					*buf;
>  } __attribute__((packed));
>  
> +static int msg_buf_len(struct tracecmd_msg *msg)

I changed this to:

static inline int msg_buf_len(...)

-- Steve

> +{
> +	return ntohl(msg->hdr.size) - MSG_HDR_LEN - ntohl(msg->hdr.cmd_size);
> +}
> +
>  static int msg_write(int fd, struct tracecmd_msg *msg)
>  {
>  	int cmd = ntohl(msg->hdr.cmd);
> @@ -425,7 +430,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
>  		goto error;
>  	}
>  
> -	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	buf_len = msg_buf_len(&msg);
>  	if (buf_len <= 0) {
>  		ret = -EINVAL;
>  		goto error;
> @@ -541,7 +546,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
>  		goto error;
>  	}
>  
> -	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	buf_len = msg_buf_len(&msg);
>  	if (buf_len < 0) {
>  		ret = -EINVAL;
>  		goto error;
> @@ -685,7 +690,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
>  			goto next;
>  		}
>  
> -		n = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +		n = msg_buf_len(&msg);
>  		t = n;
>  		s = 0;
>  		while (t > 0) {

