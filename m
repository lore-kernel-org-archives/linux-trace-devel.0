Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30553C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 18:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA26D218AC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 18:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfBNSvS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 13:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfBNSvS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 13:51:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B1FD222D0;
        Thu, 14 Feb 2019 18:51:17 +0000 (UTC)
Date:   Thu, 14 Feb 2019 13:51:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 03/11] trace-cmd: Add TRACE_REQ and TRACE_RESP
 messages
Message-ID: <20190214135115.21fc255b@gandalf.local.home>
In-Reply-To: <20190214141335.28144-4-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
        <20190214141335.28144-4-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:13:27 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> + /*
> +  * NOTE: On success, the returned `argv` should be freed with:
> +  *     free(argv[0]);
> +  *     free(argv);
> +  */
> +int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
> +				int *argc, char ***argv)
> +{
> +	struct tracecmd_msg msg;
> +	char *p, *buf_end, **args;
> +	int i, ret, nr_args;
> +	ssize_t buf_len;
> +
> +	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ) {
> +		ret = -ENOTSUP;
> +		goto out;
> +	}
> +
> +	nr_args = ntohl(msg.trace_req.argc);
> +	if (nr_args <= 0) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	buf_end = (char *)msg.buf + buf_len;
> +	if (buf_len <= 0 && ((char *)msg.buf)[buf_len-1] != '\0') {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	args = calloc(nr_args, sizeof(*args));
> +	if (!args) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	p = msg.buf;
> +	for (i = 0; i < nr_args; i++) {
> +		if (p >= buf_end) {
> +			ret = -EINVAL;
> +			goto out_args;
> +		}
> +		args[i] = p;
> +		p = strchr(p, '\0');
> +		if (!p) {
> +			ret = -EINVAL;
> +			goto out_args;
> +		}
> +		p++;
> +	}
> +
> +	/*
> +	 * On success we're passing msg.buf to the caller through argv[0] so we
> +	 * don't msg_free in this case.
> +	 */

This is OK for now, but I'm still wondering if we should just add:

	msg.buf = NULL;
	msg_free(&msg);

For robustness. What happens if for some reason in the future that we
add another allocation to msg? That would cause this to leak memory.

Yeah, yeah, this is highly paranoid, but code like this is exactly how
memory leaks come about and other bugs come about. It's taking advantage
of internals of how msg_free() works to optimize the case. And when the
internals change, things break.

No need to change anything here, I may just add the code on top of this
series.

-- Steve


> +	*argc = nr_args;
> +	*argv = args;
> +	return 0;
> +
> +out_args:
> +	free(args);
> +out:
> +	error_operation(&msg);
> +	if (ret == -EOPNOTSUPP)
> +		handle_unexpected_msg(msg_handle, &msg);
> +	msg_free(&msg);
> +	return ret;
> +}
> +
