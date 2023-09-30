Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEA3D79
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252EFC433C7;
	Sat, 30 Sep 2023 20:29:15 +0000 (UTC)
Date: Sat, 30 Sep 2023 16:29:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: add option to disable documentation
Message-ID: <20230930162913.3240773e@rorschach.local.home>
In-Reply-To: <20230930202413.2528178-1-giulio.benetti@benettiengineering.com>
References: <20230930202413.2528178-1-giulio.benetti@benettiengineering.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 30 Sep 2023 22:24:13 +0200
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

Same here (from my reply to the libtraceevent patch).

Thanks,

-- Steve


> Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
> ---
>  meson.build       | 3 +++
>  meson_options.txt | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/meson.build b/meson.build
> index 9d42d78..f1e492e 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -39,6 +39,8 @@ if cunit_dep.found()
>      subdir('utest')
>  endif
>  subdir('samples')
> +
> +if get_option('doc')
>  subdir('Documentation')
>  
>  custom_target(
> @@ -46,3 +48,4 @@ custom_target(
>      output: 'docs',
>      depends: [html, man],
>      command: ['echo'])
> +endif
> diff --git a/meson_options.txt b/meson_options.txt
> index 1d92c28..5533a88 100644
> --- a/meson_options.txt
> +++ b/meson_options.txt
> @@ -14,3 +14,5 @@ option('man-bold-literal', type : 'boolean', value : false,
>         description : 'enable bold literals')
>  option('docbook-suppress-sp', type : 'boolean', value : false,
>         description : 'docbook suppress sp')
> +option('doc', type : 'boolean', value: true,
> +       description : 'produce documentation')

