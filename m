Received: from smtpdh19-2.aruba.it (smtpdh19-2.aruba.it [62.149.155.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B079C3
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="DblZpu30"
Received: from [192.168.50.221] ([84.33.84.190])
	by Aruba Outgoing Smtp  with ESMTPSA
	id M5zErLhv7zQtAM5zFrVhE3; Sat, 06 Jan 2024 13:41:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1704544873; bh=P1Aiw46Vj2/vbaROy/qg6uuOB5A4WpW0sDimW7j/+BY=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=DblZpu30YK7S/H4Mjz08pdmIBWfoW34Q4VLtV+2wEgyH74yfD0KRCLQ+9wemITm6Z
	 P96P3lrsZBnINfiT2E6kgBmPE9EYJDXda9wAvlPA6NPB9ZxG/QgL86/HpnaoRS5ULl
	 Jlghvs0HC2Y1GqLc9i1E9A1l/9tXLzeUHuX0sbI49EriabB5hwsBoclvCPvaLgzqOw
	 atKNKoIQKa6MrbS5OYK7qKyOfig7gZcBbn7OFsdqu802UED5vgnvwakxz3WOXS1O/6
	 nWVpLc5WDTOXbrTDnA7XTOPrjwyr4q/DfALb567I96hUlrStnqcH0BifidPWqws7Ot
	 sI35RXjj8rLzQ==
Message-ID: <e5837824-0f3c-4ae5-918e-cf78dd5f3896@benettiengineering.com>
Date: Sat, 6 Jan 2024 13:41:12 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] libtracefs: add option to disable documentation
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org
References: <20230930204008.2528607-1-giulio.benetti@benettiengineering.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
In-Reply-To: <20230930204008.2528607-1-giulio.benetti@benettiengineering.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfEvhP9PE7rONjDJdrXWoscptmpB6G+YVQ4TPBoVcqkq4DKY+D5hrOpKLPf4kNgkjNky8yBdy/G2sdUFgGDMqFJKm9rIj1UHmGR0BMAyg4TO7/FFoSmpO
 HghyM2Mr/uCK1kG8VhaTPJ45fKxrfaxh/I2i5BUPPY5ti/6TG64rsX0w3wgkoQx9U5ItADGDtvj0+aWVnnOxdY1Un52V9CpqXBlGbQOn6dCYUYKxvI9y9c3W
 Vo25h+SGZ1CvfBREpAM7iFh+494hLNoz2lrlmRNyRkk=

Hi Steven,

would it be possible to commit this change before releasing new version?
This way I can add both libtracefs and libtraceevent without local
patches as you can see on this iteration to bump trace-cmd:
https://patchwork.ozlabs.org/project/buildroot/list/?series=379077

The same patch has been committed to libtraceevent:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=5b893850d20f8e4377dcdf66089d60e2559b4b26

Best regards
-- 
Giulio Benetti
CEO&CTO@Benetti Engineering sas

On 30/09/23 22:40, Giulio Benetti wrote:
> On some Linux environment builder(i.e. Buildroot) host asciidoc is not
> provided since by default all man/docs are not installed to target but
> meson.build at the moment build ascii and html documentation and
> requires asciidoc making the building to fail. So let's add doc option
> set to true by default to let the user to override it and not produce
> the documentation.
> 
> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> ---
> V1->V2:
> * improve commit log as suggested by Steve Rostedt
> ---
>   meson.build       | 3 +++
>   meson_options.txt | 2 ++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/meson.build b/meson.build
> index 9d42d78..f1e492e 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -39,6 +39,8 @@ if cunit_dep.found()
>       subdir('utest')
>   endif
>   subdir('samples')
> +
> +if get_option('doc')
>   subdir('Documentation')
>   
>   custom_target(
> @@ -46,3 +48,4 @@ custom_target(
>       output: 'docs',
>       depends: [html, man],
>       command: ['echo'])
> +endif
> diff --git a/meson_options.txt b/meson_options.txt
> index 1d92c28..5533a88 100644
> --- a/meson_options.txt
> +++ b/meson_options.txt
> @@ -14,3 +14,5 @@ option('man-bold-literal', type : 'boolean', value : false,
>          description : 'enable bold literals')
>   option('docbook-suppress-sp', type : 'boolean', value : false,
>          description : 'docbook suppress sp')
> +option('doc', type : 'boolean', value: true,
> +       description : 'produce documentation')

