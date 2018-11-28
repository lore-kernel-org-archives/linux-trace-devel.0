Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbeK2ETQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 23:19:16 -0500
Date: Wed, 28 Nov 2018 12:16:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 16/17] kernel-shark-qt: Add "Hide CPU" checkbox dialog
 to the Main window menu
Message-ID: <20181128121654.28d66d29@gandalf.local.home>
In-Reply-To: <20181128151530.21965-17-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
        <20181128151530.21965-17-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 15:16:27 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:


> +void KsMainWindow::_hideCPUs()
> +{
> +	kshark_context *kshark_ctx(nullptr);
> +	KsCheckBoxWidget *cpu_cbd;
> +	KsCheckBoxDialog *dialog;
> +
> +	if (!kshark_instance(&kshark_ctx))
> +		return;
> +
> +	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
> +	dialog = new KsCheckBoxDialog(cpu_cbd, this);
> +
> +	if (!kshark_ctx->hide_cpu_filter ||
> +	    !kshark_ctx->hide_cpu_filter->count) {
> +		cpu_cbd->setDefault(false);
> +	} else {
> +		int nCPUs = tep_get_cpus(_data.tep());
> +		QVector<bool> v(nCPUs, false);
> +
> +		for (int i = 0; i < nCPUs; ++i) {
> +			if (tracecmd_filter_id_find(kshark_ctx->hide_cpu_filter,
> +						    i))

Just a nit, but really that "i))" could have been on the previous line.

No need to send another patch, but let's not get too crazy at breaking
up lines like this ;-)

-- Steve

> +				v[i] = true;
> +		}
>
