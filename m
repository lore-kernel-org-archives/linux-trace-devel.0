Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38878 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeBHHRf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 02:17:35 -0500
Received: by mail-wr0-f195.google.com with SMTP id t94so3601531wrc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Feb 2018 23:17:34 -0800 (PST)
Message-ID: <1518074262.2041.6.camel@gmail.com>
Subject: Re: [PATCH v2 13/24] trace-cmd: Move python-related files in python/
From: "Vladislav K. Valtchev" <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Date: Thu, 08 Feb 2018 09:17:42 +0200
In-Reply-To: <20180207143606.5db63242@gandalf.local.home>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
         <20180206084906.9854-14-vladislav.valtchev@gmail.com>
         <20180207142238.74d12ec3@gandalf.local.home>
         <20180207143606.5db63242@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 2018-02-07 at 14:36 -0500, Steven Rostedt wrote:
> On Wed, 7 Feb 2018 14:22:38 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'm looking at why this breaks install, but I found another concern.
> 
> Here's the fix, I'll fold it into your patch.
> 
> -- Steve
> 
> diff --git a/Makefile b/Makefile
> index 9544d84..89bec15 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -86,6 +86,7 @@ export PLUGIN_DIR
>  export PYTHON_DIR
>  export PYTHON_DIR_SQ
>  export plugin_dir_SQ
> +export python_dir_SQ
>  export var_dir
>  

Aha, I suspected that something that subtle could be the problem!
Thanks for doing everything, Steven!

-- 
Vladislav Valtchev
VMware Open Source Technology Center
