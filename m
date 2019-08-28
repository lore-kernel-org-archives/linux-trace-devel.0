Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45146C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 05:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18EC522CF4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 05:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="h+xWkIm5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfH1FKz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 01:10:55 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21549 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfH1FKz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 01:10:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1566969024; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=JuXc9iETI0LPv2WJU9g/TAfVyhF3BcMyprafaHXKmbOGKlAqSJL+aWls8jLVxMvjujNz0sH8tWTG0Q/SQWBCy0/FUM/vXf4gnz88EUIZK45AP6msKNdURldj6Kp7Hnisxz8+oz0N3jmohim0+fhe1YlowE7z2Hs6y9iagO2yrZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1566969024; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=xWG29GENVJ2spiBEbKxnWEflZZ97Ko0Peuhb8HQlWVI=; 
        b=BJ3uuLaYAYvOCOXEAoKUXlMPK6uRUYE9qE5XrCXLm28iE/IS8bZQqxzmNNUZtGZlhPxuENJIa6j472I6yMgF7BvLhlBOZXoQT9WnEU9Gvi2eJuurIMehIPGaemQxTiEpJr2bP71RTBb6S3XGcbv0f+K98KhkQ8FzhuAArcOshMI=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1566969024;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        l=3424; bh=xWG29GENVJ2spiBEbKxnWEflZZ97Ko0Peuhb8HQlWVI=;
        b=h+xWkIm52dxST89Llj5fPGb0zkvWbR3TaRaF0JNiPndGvGRsfnCqMQ/jllfVJIhT
        uTmZoyffnA009eiX1CMu5y5n1hKRxau/zok5pwvcA3rw8Bj5gOrI9oCPgJMGb3+TyvK
        pQXyV6MepYoYwCEWolX4Q+DSb+Jh2d8tMGtstyYs=
Received: from localhost (c-73-241-204-195.hsd1.ca.comcast.net [73.241.204.195]) by mx.zohomail.com
        with SMTPS id 1566969023118641.2775918880387; Tue, 27 Aug 2019 22:10:23 -0700 (PDT)
Date:   Tue, 27 Aug 2019 22:10:18 -0700
From:   stephen@brennan.io
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
Message-ID: <20190828051018.GA5316@greed>
References: <20190827131418.18713-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131418.18713-1-y.karadz@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ZohoMailClient: External
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan!

Thanks for the quick work on this issue :)

On Tue, Aug 27 16:14, Yordan Karadzhov (VMware) wrote:
> Shell-like parsing of quotation marks in the content of the "Command"
> field of the "Record" dialog will give more options to the users.
> For example, now we can trace
> 
>  python -c 'print("hello world")'
> 
> Suggested-by: Stephen Brennan <stephen@brennan.io>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204679
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/KsCaptureDialog.cpp | 38 ++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
> index dc1e9b2..b3393b6 100644
> --- a/kernel-shark/src/KsCaptureDialog.cpp
> +++ b/kernel-shark/src/KsCaptureDialog.cpp
> @@ -157,7 +157,9 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
>   */
>  QStringList KsCaptureControl::getArgs()
>  {
> +	QString::SplitBehavior opt = QString::SkipEmptyParts;
>  	QStringList argv;
> +	QString cmdTmp;
>  
>  	argv << "record";
>  
> @@ -170,7 +172,36 @@ QStringList KsCaptureControl::getArgs()
>  		argv << _eventsWidget.getCheckedEvents(true);
>  
>  	argv << "-o" << outputFileName();
> -	argv << _commandLineEdit.text().split(" ");
> +
> +	cmdTmp = _commandLineEdit.text();
> +	if (!cmdTmp.contains('\'') && !cmdTmp.contains('\"')) {
> +		/* Split all command line arguments. */
> +		argv << cmdTmp.split(" ", opt);
> +	} else {
> +		int iOpenQuots, iCloseQuots, size = cmdTmp.size();
> +		int iSingleQuots = (cmdTmp.count('\'') == 2) ? cmdTmp.indexOf('\'') : size;
> +		int iDoubleQuots = (cmdTmp.count('\"') == 2) ? cmdTmp.indexOf('\"') : size;
> +
> +		if (iSingleQuots < iDoubleQuots) {
> +			iOpenQuots = iSingleQuots;
> +			iCloseQuots = cmdTmp.lastIndexOf('\'') + 1;
> +		} else if (iDoubleQuots < iSingleQuots) {
> +			iOpenQuots = iDoubleQuots;
> +			iCloseQuots = cmdTmp.lastIndexOf('\"') + 1;
> +		} else {
> +			emit print("\nERROR: Unable to parse the command.");
> +			return {};
> +		}
> +
> +		/* Split the arguments. */
> +		argv << cmdTmp.left(iOpenQuots).split(" ", opt);
> +
> +		/* Everything in between the quotation marks goes in one piece. */
> +		argv << cmdTmp.mid(iOpenQuots, iCloseQuots - iOpenQuots);
> +
> +		/* Split the rest of the arguments. */
> +		argv << cmdTmp.right(size - iCloseQuots).split(" ", opt);
> +	}

It strikes me that this explicitly supports only a single set of quotes.
This sort of behavior would be pretty surprising for people expecting shell
quote support, and for people expecting just splitting on spaces.

I looked and couldn't really find any Qt utility for properly parsing shell
quoting (similar to python's shlex module). I totally get that it's a lot
of work to implement a correct shell quoting parser.

Maybe a compromise would be to add a checkbox to the capture dialog, which
tells kernel-shark to pass the entire textbox contents, unmodified, to the
shell implementation on the system. So, my example of:

    python -c 'print("hello world")'

Would get put into the third argument of the command:

    /bin/sh -c INSERT_TEXTBOX_CONTENTS_HERE

Then you could rely on /bin/sh doing the parsing for you. The downside is
that it adds a whole new process. But you can't always get everything in
life, right?

Hope this was helpful!

Stephen

