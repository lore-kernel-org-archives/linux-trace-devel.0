Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8BFC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F3D20675
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfAPQhl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfAPQhk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 11:37:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D603B20657;
        Wed, 16 Jan 2019 16:37:39 +0000 (UTC)
Date:   Wed, 16 Jan 2019 11:37:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 08/46] tools/lib/traceevent: Man page for
 tep_is_file_bigendian() and tep_set_file_bigendian()
Message-ID: <20190116113738.6752389c@gandalf.local.home>
In-Reply-To: <20181127154153.11315-9-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
        <20181127154153.11315-9-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Nov 2018 15:42:16 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_is_file_bigendian() and tep_set_file_bigendian()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-file_endian.txt             | 89 +++++++++++++++++++
>  1 file changed, 89 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> new file mode 100644
> index 000000000000..2b763aaf9c6b
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
> @@ -0,0 +1,89 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_file_bigendian,tep_set_file_bigendian - Get / set the endianess of the 
> +raw data, being accessed by the tep handler. 
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_endian* {
> +	TEP_LITTLE_ENDIAN = 0,
> +	TEP_BIG_ENDIAN
> +};
> +
> +int *tep_file_bigendian*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
> +
> +--
> +DESCRIPTION
> +-----------
> +The _tep_file_bigendian()_ function returns the endianess of the raw data,
> +being accessed by the tep handler. The _tep_ argument is trace event parser context.

FYI, I removed the comma from the above "the raw_data being accessed"

> +
> +The _tep_set_file_bigendian()_ set the endianess of raw data, the being accessed 
> +by the tep handler. The _tep_ argument is trace event parser context.

I also changed the above to "of raw data being accessed"

-- Steve

> +[verse]
> +--
