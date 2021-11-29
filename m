Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06DEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhK2UWB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 15:22:01 -0500
Received: from linux.microsoft.com ([13.77.154.182]:44616 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhK2USa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 15:18:30 -0500
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0805D20DEE27;
        Mon, 29 Nov 2021 12:15:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0805D20DEE27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638216912;
        bh=2iCT3NVa46Q0Id1kx1384GhV/gp1P7e2Vnbxu3avVCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XP0f3gSLBi+xzRQz+PItRPBPwSVsm/uqtujHF70DUuopGg8s6jx2TQefLATbai+tc
         OLr594/tbQXXj2bPAHnMuPD6tMaixRdsx0ooOa7BWm+8qXGBSBn2ICe+LUsp6CgGfo
         ER8pri1lVt5U4CdbgRD/GuImRrLIIerH02rZ/LGk=
Date:   Mon, 29 Nov 2021 12:15:07 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211129201507.GA30603@kbox>
References: <20211122223909.15f6fb50@rorschach.local.home>
 <163767457857.543504.6091850281066240970.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163767457857.543504.6091850281066240970.stgit@devnote2>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 23, 2021 at 10:36:18PM +0900, Masami Hiramatsu wrote:
> Add '__rel_loc' new dynamic data location attribute which encodes
> the data location from the next to the field itself. This is similar
> to the '__data_loc' but the location offset is not from the event
> entry but from the next of the field.
> 
> This patch adds '__rel_loc' decoding support in the libtraceevent.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  Changes in v2:
>    - Fix to adjust '*offset' instead of 'offset' in dynamic_offset_field()
> ---
>  src/event-parse.c  |   54 +++++++++++++++++++++++++++++++++-------------------
>  src/event-parse.h  |    5 +++--
>  src/parse-filter.c |    5 ++++-
>  3 files changed, 41 insertions(+), 23 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 70637586bc9a..a88c73a8d0fb 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c

[..]

> @@ -3308,19 +3318,23 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
>  		free_token(token);
>  		return process_int_array(event, arg, tok);
>  	}
> -	if (strcmp(token, "__get_str") == 0) {
> +	if (strcmp(token, "__get_str") == 0 ||
> +	    strcmp(token, "__get_rel_str") == 0) {

Should user_events use __get_rel_str vs __get_str for the print_fmt?
Both __dyn_loc and __rel_loc use __get_str currently.

Thanks,
-Beau
