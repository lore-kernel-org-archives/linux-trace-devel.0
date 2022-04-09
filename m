Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBA3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Apr 2022 00:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiDIAZz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 20:25:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49908 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiDIAZy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 20:25:54 -0400
Received: from [IPV6:2620:137:e001:0:2494:425a:f48e:322] (unknown [IPv6:2620:137:e001:0:2494:425a:f48e:322])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A053D8418213;
        Fri,  8 Apr 2022 17:23:48 -0700 (PDT)
Message-ID: <d5569c98-a41a-ebad-dafe-ff0819361fb6@eaglescrag.net>
Date:   Fri, 8 Apr 2022 17:23:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] setup.py: fix string <-> int comparison
Content-Language: en-US
From:   John 'Warthog9' Hawley <warthog9@eaglescrag.net>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
References: <20220409002155.1346141-1-warthog9@eaglescrag.net>
In-Reply-To: <20220409002155.1346141-1-warthog9@eaglescrag.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 08 Apr 2022 17:23:48 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sorry also should have specified this is trace-cruncher specific

- John

On 4/8/2022 5:21 PM, John 'Warthog9' Hawley (VMware) wrote:
> Slightly older (read: python 3.6ish) seem to treat the language_level
> object as an integer all the time.  If you end up passing the version
> in as a string (with the 's) it ends up doing a string to int comparison
> and throws an error.  Newer python will deal with the non-matching
> typing fine and this isn't an issue there.
> 
> So minor fix to be slightly more correct with relation to older python
> 
> Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
> ---
>   setup.py | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/setup.py b/setup.py
> index 21c627f..58561cf 100644
> --- a/setup.py
> +++ b/setup.py
> @@ -74,7 +74,7 @@ def main():
>                             sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
>                             libraries=['traceevent', 'tracefs'])
>   
> -    cythonize('src/npdatawrapper.pyx', language_level = '3')
> +    cythonize('src/npdatawrapper.pyx', language_level = 3)
>       module_data = extension(name='tracecruncher.npdatawrapper',
>                               sources=['src/npdatawrapper.c'],
>                               libraries=['kshark'])
