Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfAHXBh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 18:01:37 -0500
Date: Tue, 8 Jan 2019 18:01:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v2 5/6] trace-cmd: Add TRACE_REQ and TRACE_RESP messages
Message-ID: <20190108180134.43a89390@gandalf.local.home>
In-Reply-To: <20190108150015.21327-6-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
        <20190108150015.21327-6-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  8 Jan 2019 17:00:14 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add TRACE_REQ and TRACE_RESP messages which are used for initiating guest VM
> tracing.
> 
> + /*
> +  * NOTE: On success, the returned `argv` should be freed with:
> +  *     free(argv[0]);
> +  *     free(argv);
> +  */
> +int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
> +				int *argc, char ***argv)
> +{
> +	struct tracecmd_msg msg;
> +	char *p, *buf_end;
> +	size_t buf_len;
> +	int i, ret;
> +
> +	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ)
> +		goto out;
> +
> +	if (ntohl(msg.trace_req.argc) < 0)
> +		goto out;
> +
> +	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	buf_end = (char *)msg.buf + buf_len;
> +	p = msg.buf;
> +	*argc = ntohl(msg.trace_req.argc);
> +	*argv = calloc(*argc, sizeof(**argv));

Need to test for failed calloc().

> +	for (i = 0; i < *argc; i++) {
> +		if (p >= buf_end) {
> +			ret = -1;
> +			free(*argv);
> +			goto out;
> +		}
> +
> +		(*argv)[i] = p;
> +		p = strchr(p, '\0');
> +		p++;
> +	}
> +
> +	ret = 0;

Should add a comment here saying that we are passing msg.buf as
argv[0], and we don't want to have msg_free() free it.

> +	msg.buf = NULL;
> +
> +out:

Need to free argv and argv[0] as the description only says that the
caller has to free it on success. Make sure to set those pointers to
zero (NULL) afterward.

> +	msg_free(&msg);
> +	return ret;
> +}
> +
> +static int make_trace_resp(struct tracecmd_msg *msg,
> +			   int page_size, int nr_cpus, int *ports)
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
> +				 int nr_cpus, int page_size, int *ports)
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
> +				 int *nr_cpus, int *page_size, int **ports)
> +{
> +	struct tracecmd_msg msg;
> +	size_t buf_len;
> +	int i, ret;
> +
> +	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ntohl(msg.hdr.cmd) != MSG_TRACE_RESP) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
> +	if (buf_len <= 0 ||
> +	    buf_len != sizeof(*msg.port_array) * ntohl(msg.trace_resp.cpus)) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	*nr_cpus = ntohl(msg.trace_resp.cpus);
> +	*page_size = ntohl(msg.trace_resp.page_size);
> +	*ports = calloc(*nr_cpus, sizeof(**ports));

Again, this needs to test the result of calloc().

-- Steve

> +	for (i = 0; i < *nr_cpus; i++)
> +		(*ports)[i] = ntohl(msg.port_array[i]);
> +
> +	ret = 0;
> +
> +out:
> +	msg_free(&msg);
> +	return ret;
> +}
> +
> +int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
> +{
> +	char buf[BUFSIZ];
> +	int ret;
> +
> +	for (;;) {
> +		ret = read(msg_handle->fd, buf, sizeof(buf));
> +		if (ret <= 0)
> +			return ret;
> +	}
> +
> +	return -1;
> +}
