Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB835C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 18:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7F4D20643
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 18:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCMSgu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 14:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfCMSgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 14:36:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C21F20643;
        Wed, 13 Mar 2019 18:36:48 +0000 (UTC)
Date:   Wed, 13 Mar 2019 14:36:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 23/46] tools/lib/traceevent: Man pages
 tep_get_any_field_val(), tep_get_common_field_val(), tep_get_field_val()
 and tep_get_field_raw()
Message-ID: <20190313143647.7dac33e2@gandalf.local.home>
In-Reply-To: <20190308133654.21264-24-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-24-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:31 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_get_any_field_val(), tep_get_common_field_val(),
> tep_get_field_val() and tep_get_field_raw() as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-field_get_val.txt           | 117 ++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
> new file mode 100644
> index 000000000000..dbb4875c49fb
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
> @@ -0,0 +1,117 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_get_any_field_val,tep_get_common_field_val,tep_get_field_val,tep_get_field_raw - Get value of a field.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +*#include <trace-seq.h>*
> +
> +int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
> +int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
> +int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
> +void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int pass:[*]_len_, int _err_);
> +--
> +
> +DESCRIPTION
> +-----------
> +These functions can be used to find a field and retrieve its value.
> +
> +The _tep_get_any_field_val()_ function searches in the _record_ for a filed with

s/filed/field/

> +_name_, part of the _event_. If the field is found, its value is stored in _val_.
> +In case of an error, an error string is printed into _s_, if _err_ is not 0.

The above is worded in a confusing way. May want to make it:

 "If there is an error and _err_ is not zero, then an error string is
  written into _s_."


> +
> +The _tep_get_common_field_val()_ function does the same as
> +_tep_get_any_field_val()_, but searches only in the common fields.

Add "This will work for any event as all events include the common
fields".

> +
> +The _tep_get_field_val()_ function does the same as
> +_tep_get_any_field_val()_, but searches only in the event specific fields.
> +
> +The _tep_get_field_raw()_ function searches in the _record_ for a filed with _name_,

 /filed/field/

> +part of the _event_. If the field is found, a pointer to its raw data is returned.
> +The size of the data is stored in _len_. In case of an error, an error string
> +is printed into _s_, if _err_ is not 0.

Change that last sentence too.

-- Steve

> +
> +RETURN VALUE
> +------------
> +The _tep_get_any_field_val()_, _tep_get_common_field_val()_ and
> +_tep_get_field_val()_ functions return 0 on success, or -1 in case of an error.
> +
> +The _tep_get_field_raw()_ function returns a pointer to field's raw data, and
> +places the length of this data in _len_. In case of an error NULL is returned.
> +
