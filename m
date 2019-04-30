Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA55C43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A08DF21743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfD3WIq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:08:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F5E320835;
        Tue, 30 Apr 2019 22:08:44 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:08:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 15/30] tools/lib/traceevent: Man pages for event find
 APIs
Message-ID: <20190430180842.7d1a3865@gandalf.local.home>
In-Reply-To: <20190412133811.15878-16-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-16-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:56 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for libtraceevent APIs:
>   tep_find_event()
>   tep_find_event_by_name()
>   tep_find_event_by_record()
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-event_find.txt              | 101 ++++++++++++++++++
>  1 file changed, 101 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
> new file mode 100644
> index 000000000000..797a5cb4e38a
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
> @@ -0,0 +1,101 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_find_event,tep_find_event_by_name,tep_find_event_by_record -
> +Find events by given key.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
> +struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
> +struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_record_);
> +--
> +
> +DESCRIPTION
> +-----------
> +This set of functions can be used to search for an event, based on a given
> +criteria. All functions require a pointer to a _tep_, trace event parser
> +context.
> +
> +The _tep_find_event()_ function searches for an event by given event _id_.

I would state that the id is the number that corresponds to the ID:
number that is found in the tracefs event format file.

-- Steve

> +
> +The tep_find_event_by_name()_ function searches for an event by given
> +event _name_, under the system _sys_. If the _sys_ is NULL (not specified),
> +the first event with _name_ is returned.
> +
> +The tep_find_event_by_record()_ function searches for an event from a given
> +_record_.
> +
> +RETURN VALUE
> +------------
> +All these functions return a pointer to the found event, or NULL if there is no
> +such event.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +struct tep_event *event;
> +
> +event = tep_find_event(tep, 1857);
> +if (event == NULL) {
> +	/* There is no event with ID 1857 */
> +}
> +
> +event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
> +if (event == NULL) {
> +	/* There is no kvm_exit event, from kvm system */
> +}
> +
> +void event_from_record(struct tep_record *record)
> +{
> + struct tep_event *event = tep_find_event_by_record(tep, record);
> +	if (event == NULL) {
> +		/* There is no event from given record */
> +	}
> +}
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

