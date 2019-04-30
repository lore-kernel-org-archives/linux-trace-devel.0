Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F89FC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 23:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1F82085A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 23:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfD3X6C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 19:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfD3X6C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 19:58:02 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA13B20828;
        Tue, 30 Apr 2019 23:58:01 +0000 (UTC)
Date:   Tue, 30 Apr 2019 19:58:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 22/30] tools/lib/traceevent: Man page for
 tep_read_number_field()
Message-ID: <20190430195800.5089a12e@oasis.local.home>
In-Reply-To: <20190412133811.15878-23-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-23-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:03 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man page for libtraceevent API tep_read_number_field().
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-field_read.txt              | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
> new file mode 100644
> index 000000000000..0c560c416ac2
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
> @@ -0,0 +1,80 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_read_number_field - Reads a number from a raw data.

 "Reads a number from raw data"

> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const void pass:[*]_data_, unsigned long long pass:[*]_value_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_read_number_field()_ function reads the value of the _field_ from the
> +raw _data_ and stores it in the _value_. The function sets the _value_ according

 and stores it in _value_

-- Steve

> +to the endianness of the raw data and the current machine.
> +
