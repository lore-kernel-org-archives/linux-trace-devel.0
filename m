Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179DFC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B472146E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfCMRms (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfCMRms (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 13:42:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03DF213A2;
        Wed, 13 Mar 2019 17:42:46 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:42:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 22/46] tools/lib/traceevent: Man pages
 tep_find_common_field(), tep_find_field() and tep_find_any_field()
Message-ID: <20190313134244.1eb8f9af@gandalf.local.home>
In-Reply-To: <20190308133654.21264-23-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-23-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:30 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_find_common_field(), tep_find_field()
> and tep_find_any_field() as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-field_find.txt              | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
> new file mode 100644
> index 000000000000..b941988429a0
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
> @@ -0,0 +1,98 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_find_common_field,tep_find_field,tep_find_any_field - Search for a field in an event.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
> +struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat pass:[*]_event_, const char pass:[*]_name_);
> +struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
> +--
> +
> +DESCRIPTION
> +-----------
> +These functions search for a field with given name in an event.
> +
> +The _tep_find_common_field()_ function searches for a common field with _name_
> +in the _event_.
> +
> +The _tep_find_field()_ function searches for an event specific field with
> +_name_ in the _event_.
> +
> +The _tep_find_any_field()_ function searches for any field with _name_ in the
> +_event_.
> +

I would state also how these fields can be used. Something like:

"The field returned can then be used to find the field content from
within a data record."


> +RETURN VALUE
> +------------
> +The _tep_find_common_field(), _tep_find_field()_ and _tep_find_any_field()_
> +functions return a pointer to the found field, or NULL in case there is no field
> +with the requested name.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +struct tep_event *event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
> +...
> +	struct tep_format_field *field;
> +
> +	field = tep_find_common_field(event, "common_pid");
> +	if (field == NULL) {
> +		/* Cannot find "common_pid" common field in the event */
> +	}

Perhaps add what to do with this:

	pid = tep_read_number(tep, record->data + field->offset, field->size);

-- Steve

 
> +
> +	field = tep_find_field(event, "softexpires");
> +	if (field == NULL) {
> +		/* Cannot find "softexpires" event specific field in the event */
> +	}
> +
> +	field = tep_find_any_field(event, "mode");
> +	if (field == NULL) {
> +		/* Cannot find "mode" field in the event */
> +	}
> +...
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

