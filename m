Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbeHXS6M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 14:58:12 -0400
Date: Fri, 24 Aug 2018 11:23:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] kernel-shark-qt: Add an example showing how to
 draw shapes and Graphs.
Message-ID: <20180824112303.7fab6bdd@gandalf.local.home>
In-Reply-To: <20180824142116.21339-5-y.karadz@gmail.com>
References: <20180824142116.21339-1-y.karadz@gmail.com>
        <20180824142116.21339-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 24 Aug 2018 17:21:16 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +int main(int argc, char **argv)
> +{
> +	struct kshark_context *kshark_ctx(nullptr);
> +	struct kshark_entry **data(nullptr);
> +	static char *input_file;
> +	bool status, shapes(false);
> +	size_t r, n_rows;
> +	int c, nBins;
> +
> +	while ((c = getopt(argc, argv, "si")) != -1) {
> +		switch(c) {
> +		case 'i':
> +			input_file = optarg;
> +			break;
> +		case 's':
> +			shapes = true;
> +
> +		default:
> +			break;
> +		}
> +	}
> +
> +	/* Create a new kshark session. */
> +	if (!kshark_instance(&kshark_ctx))

Should make some warning message. I ran this from the build directory
like:

 ../bin/dplot ../../trace.dat

and it did nothing. But if I ran it from the trace-cmd.git repo as

kernel-shark-qt/bin/dplot trace.dat

Then it did something. We need to make it work when called from
anywhere with a path to any trace.dat file. And give some kind of
message if no parameter is passed in.

Hmm, we should also probably make a separate directory for example
programs. Perhaps have a "demo" directory for these?

-- Steve

> +		return 1;
> +
> +	/* Open a trace data file produced by trace-cmd. */
> +	if (input_file)
> +		status = kshark_open(kshark_ctx, input_file);
> +	else
> +		status = kshark_open(kshark_ctx, default_file);
> +
> +	if (!status) {
> +		kshark_free(kshark_ctx);
> +		return 1;
> +	}
> +
