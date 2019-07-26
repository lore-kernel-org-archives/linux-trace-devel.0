Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76535C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53EEF206BF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfGZH3v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:29:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44346 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfGZH3v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:29:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hqufk-0006oG-73; Fri, 26 Jul 2019 09:29:48 +0200
Message-ID: <cbceab11dc53d393e34b6c45d1ecf79ba932a5ed.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] trace-cmd: Replace PySting_FromString() with
 PyUnicode_FromString()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, Darren Hart <dvhart@infradead.org>,
        troyengel@gmail.com
Date:   Fri, 26 Jul 2019 09:29:47 +0200
In-Reply-To: <20190719225030.187908166@goodmis.org>
References: <20190719224613.207069107@goodmis.org>
         <20190719225030.187908166@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2019-07-19 at 18:46 -0400, Steven Rostedt wrote:

> --- a/python/ctracecmd.i
> +++ b/python/ctracecmd.i
> @@ -108,7 +108,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
>  		    ((int)addr == -1))
>  			break;
>  		func = tep_find_function(event->tep, addr);
> -		if (PyList_Append(list, PyString_FromString(func))) {
> +		if (PyList_Append(list, PyUnicode_FromString(func))) {
>  			Py_DECREF(list);

This assumes that the source code is not using extended identifiers (per
C99, gcc -fextended-identifiers). I think that's probably a reasonable
assumption :-)

In theory, a bit safer would be to use PyBytes_FromString() and let the
python plugin worry about the encoding.

That really applies to all of the instances here, I think, since the
strings eventually come from (macros in the) code.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

