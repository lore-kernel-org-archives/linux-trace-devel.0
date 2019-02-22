Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCF8C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 21:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82AE42070B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 21:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfBVVJc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 16:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbfBVVJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 16:09:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196C7206BA;
        Fri, 22 Feb 2019 21:09:31 +0000 (UTC)
Date:   Fri, 22 Feb 2019 16:09:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v8 05/13] trace-cmd: Add TRACE_REQ and TRACE_RESP
 messages
Message-ID: <20190222160929.776ac227@gandalf.local.home>
In-Reply-To: <20190222180539.27439-6-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
        <20190222180539.27439-6-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Feb 2019 20:05:31 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> +static int make_trace_resp(struct tracecmd_msg *msg,
> +			   int page_size, int nr_cpus, unsigned int *ports)

I wonder if we should just have a generic "argc"/"argv" protocol to
send dynamic amounts of data, and not have specific dynamic messages?

Perhaps pass the numbers as ASCII? And then converted them at the other
end. We need to handle ntoh anyway, so a conversion (albeit a fast one)
is probably done anyway.

We could send:
 int argc =  6;
 char **argv = { "4096", "16", "33445", "33446", "33448", "33449" };

Or, if you are not comfortable with sending ASCII and converting, what
about have a specific "sending an array of numbers"?

 int argc = 6;
 int *argv = { 4096, 16, 33445, 33446, 33448, 33449 };

Thoughts?

-- Steve

> +{
> +	int ports_size = nr_cpus * sizeof(*msg->port_array);
> +	int i;
> +
> +	msg->hdr.size = htonl(ntohl(msg->hdr.size) + ports_size);
> +	msg->trace_resp.cpus = htonl(nr_cpus);
> +	msg->trace_resp.page_size = htonl(page_size);
> +
> +	msg->port_array = malloc(ports_size);
> +	if (!msg->port_array)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_cpus; i++)
> +		msg->port_array[i] = htonl(ports[i]);
> +
> +	return 0;
> +}
> +
> +int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
> +				 int nr_cpus, int page_size,
> +				 unsigned int *ports)
> +{
> +	struct tracecmd_msg msg;
> +	int ret;
> +
> +	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
> +	ret = make_trace_resp(&msg, page_size, nr_cpus, ports);
> +	if (ret < 0)
> +		return ret;
> +
> +	return tracecmd_msg_send(msg_handle->fd, &msg);
> +}
> +
> +int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
> +				 int *nr_cpus, int *page_size,
> +				 unsigned int **ports)
> +{
> +	struct tracecmd_msg msg;
> +	ssize_t buf_len;
> +	int i, ret;
> +
> +	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ntohl(msg.hdr.cmd) != MSG_TRACE_RESP) {
> +		ret = -ENOTSUP;
> +		goto out;
> +	}
> +
> +	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	if (buf_len <= 0 ||
> +	    buf_len != sizeof(*msg.port_array) * ntohl(msg.trace_resp.cpus)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	*nr_cpus = ntohl(msg.trace_resp.cpus);
> +	*page_size = ntohl(msg.trace_resp.page_size);
> +	*ports = calloc(*nr_cpus, sizeof(**ports));
> +	if (!*ports) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	for (i = 0; i < *nr_cpus; i++)
> +		(*ports)[i] = ntohl(msg.port_array[i]);
> +
> +	msg_free(&msg);
> +	return 0;
> +
> +out:
> +	error_operation(&msg);
> +	if (ret == -EOPNOTSUPP)
> +		handle_unexpected_msg(msg_handle, &msg);
> +	msg_free(&msg);
> +	return ret;
> +}

