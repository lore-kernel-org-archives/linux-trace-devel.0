Return-Path: <SRS0=lLmH=O3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbeLRXZZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Dec 2018 18:25:25 -0500
Date: Tue, 18 Dec 2018 18:25:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: fix deletion of histogram triggers
Message-ID: <20181218182522.3d601a7e@gandalf.local.home>
In-Reply-To: <20181218103928.18345-1-tstoyanov@vmware.com>
References: <20181218103928.18345-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 18 Dec 2018 12:39:28 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch fixes the clear_trigger() function to delete
> configured histograms. Unlike other triggers, histograms
> must be deleted specifying the whole trigger string.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Applied. Thanks Tzvetomir!

-- Steve

> ---
>  tracecmd/trace-record.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index a9bcd8d..37a2d1d 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -1680,7 +1680,7 @@ static void clear_trigger(const char *file)
>  	 * to the file for each trigger.
>  	 */
>  	do {
> -		len = find_trigger(file, trigger+1, BUFSIZ-1, 1);
> +		len = find_trigger(file, trigger+1, BUFSIZ-1, 3);
>  		if (len)
>  			write_trigger(file, trigger);
>  	} while (len);
