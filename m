Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B150CC4321E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Nov 2022 02:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiKZCS5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKZCS4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 21:18:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A043F317F2
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 18:18:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD0A2CE2E61
        for <linux-trace-devel@vger.kernel.org>; Sat, 26 Nov 2022 02:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786ADC433D6;
        Sat, 26 Nov 2022 02:18:49 +0000 (UTC)
Date:   Fri, 25 Nov 2022 21:18:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC v2] libtraceevent: Add initial support for meson
Message-ID: <20221125211847.69b535ea@rorschach.local.home>
In-Reply-To: <20220707142723.8721-1-dwagner@suse.de>
References: <20220707142723.8721-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jul 2022 16:27:23 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> Add support for building the project with meson. It's not complete
> yet, for example building and installing the documentation is missing.
> 
> The rest should work as expected. The only thing I was not really
> clear what the purpose is the libtraceevent-dynamic-list which seems
> not be used or installed. The meson build will also generate the file
> but using the host nm and not the cross tool chain if any is used. I
> didn't want to invest too much time figuring out this detail if it is
> actually not used.

It came over from the perf update. See:

  f1489e5dce74a ("tools lib traceevent: Export dynamic symbols used by traceevent plugins")

Not sure it's still needed or not.

> 
> Obviously, meson is not make and there are some changes in how to use
> this build system. The meson documentation is outstanding good and
> usually has good tips and tricks to solve problems. But sure there is
> learning curve but hopefully not so step.
> 
> Anyway, as pure user the build steps are (in source tree builds are
> not supported):
> 
>   # configure using .build as build directory and install destination
>   # /tmp/test
>   meson .build --prefix=/tmp/test
> 
>   # trigger the build
>   ninja -C .build
> 
>   # install the library
>   ninja -C .build install

When this is all and done, it should still be part of "make".

That is, make could do the above for the user.

> 
> I am using an alias for 'ninja -C .build' which is called 'ni'. This
> makes way more convenient to use.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> v2:
>  - changed include path exported in pkg-config
>    exports the same paths as per Makefile
> 
> v1:
>  - initial version
> 
>  include/traceevent/meson.build | 12 ++++++++++
>  meson.build                    | 38 ++++++++++++++++++++++++++++++++
>  meson_options.txt              |  2 ++
>  plugins/dynamic_list.sh        | 14 ++++++++++++
>  plugins/meson.build            | 40 ++++++++++++++++++++++++++++++++++
>  src/meson.build                | 35 +++++++++++++++++++++++++++++
>  utest/meson.build              | 14 ++++++++++++
>  7 files changed, 155 insertions(+)
>  create mode 100644 include/traceevent/meson.build
>  create mode 100644 meson.build
>  create mode 100644 meson_options.txt
>  create mode 100755 plugins/dynamic_list.sh
>  create mode 100644 plugins/meson.build
>  create mode 100644 src/meson.build
>  create mode 100644 utest/meson.build
> 
> diff --git a/include/traceevent/meson.build b/include/traceevent/meson.build
> new file mode 100644
> index 000000000000..8e114cccf627
> --- /dev/null
> +++ b/include/traceevent/meson.build
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +headers = [
> +   'event-parse.h',
> +   'event-utils.h',
> +   'kbuffer.h',
> +   'trace-seq.h',
> +]
> +
> +foreach h : headers
> +	install_headers(h, subdir : 'traceevent')
> +endforeach
> diff --git a/meson.build b/meson.build
> new file mode 100644
> index 000000000000..ef27a12fe76a
> --- /dev/null
> +++ b/meson.build
> @@ -0,0 +1,38 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +project(
> +    'libtraceevent', ['c'],
> +    meson_version: '>= 0.47.0',

I get a warning:

WARNING: Project specifies a minimum meson_version '>= 0.47.0' but uses features which were added in newer versions:
 * 0.50.0: {'include_directories kwarg of type string'}


> +    license: 'LGPL-2.1',
> +    version: '1.5.3',
> +    default_options: [
> +      'c_std=gnu99',
> +      'buildtype=release',
> +      'prefix=/usr',

default should be in /usr/local

-- Steve

> +      'warning_level=1',
> +    ]
> +)
> +
> +library_version = meson.project_version()
> +
> +cunit_dep = dependency('cunit', required : false)
> +
> +prefixdir  = get_option('prefix')
> +libdir     = join_paths(prefixdir, get_option('libdir'))
> +
> +plugindir  = get_option('plugindir') == '' ? join_paths(libdir, 'libtraceevent/plugins') : get_option('plugindir')
> +
> +add_project_arguments(
> +    [
> +      '-D_GNU_SOURCE',
> +      '-DPLUGIN_DIR="@0@"'.format(plugindir),
> +    ],
> +    language : 'c',
> +)
> +
> +incdir = include_directories(['include', 'include/traceevent'])
> +
> +subdir('src')
> +subdir('include/traceevent')
> +subdir('plugins')
> +subdir('utest')
> diff --git a/meson_options.txt b/meson_options.txt
> new file mode 100644
> index 000000000000..ee52f11799dd
> --- /dev/null
> +++ b/meson_options.txt
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +option('plugindir', type : 'string', description : 'set the plugin dir')
> diff --git a/plugins/dynamic_list.sh b/plugins/dynamic_list.sh
> new file mode 100755
> index 000000000000..e1480eaa694f
> --- /dev/null
> +++ b/plugins/dynamic_list.sh
> @@ -0,0 +1,14 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +symbol_type=$(nm -u -D $@ | awk 'NF>1 {print $1}' | xargs echo "U w W" |
> +	      tr 'w ' 'W\n' | sort -u | xargs echo)
> +
> +if [ "$symbol_type" = "U W" ]; then
> +	echo '{'
> +
> +	nm -u -D $@ | awk 'NF>1 {sub("@.*", "", $2); print "\t"$2";"}' |
> +	sort -u
> +
> +	echo '};'
> +fi
> diff --git a/plugins/meson.build b/plugins/meson.build
> new file mode 100644
> index 000000000000..659f864581d0
> --- /dev/null
> +++ b/plugins/meson.build
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +plugins = [
> +    'plugin_jbd2.c',
> +    'plugin_hrtimer.c',
> +    'plugin_kmem.c',
> +    'plugin_kvm.c',
> +    'plugin_mac80211.c',
> +    'plugin_sched_switch.c',
> +    'plugin_function.c',
> +    'plugin_futex.c',
> +    'plugin_xen.c',
> +    'plugin_scsi.c',
> +    'plugin_cfg80211.c',
> +    'plugin_tlb.c',
> +]
> +
> +pdeps = []
> +foreach plugin : plugins
> +    pdeps += library(
> +        plugin.replace('.c', ''),
> +        plugin,
> +        name_prefix: '',
> +        version: library_version,
> +        dependencies: [libtraceevent_dep],
> +        include_directories: [incdir],
> +        install: true,
> +        install_dir: plugindir)
> +endforeach
> +
> +# not used?
> +dynamic_list_file = find_program('dynamic_list.sh')
> +custom_target(
> +    'dynamic_list',
> +    depends: pdeps,
> +    input: pdeps,
> +    output: 'libtraceevent-dynamic-list',
> +    command: [dynamic_list_file, '@INPUT@'],
> +    capture: true,
> +    build_by_default: true)
> diff --git a/src/meson.build b/src/meson.build
> new file mode 100644
> index 000000000000..eca4f489d963
> --- /dev/null
> +++ b/src/meson.build
> @@ -0,0 +1,35 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +sources= [
> +   'event-parse-api.c',
> +   'event-parse.c',
> +   'event-plugin.c',
> +   'kbuffer-parse.c',
> +   'parse-filter.c',
> +   'parse-utils.c',
> +   'tep_strerror.c',
> +   'trace-seq.c',
> +]
> +
> +libtraceevent = library(
> +    'traceevent',
> +    sources,
> +    version: library_version,
> +    include_directories: [incdir],
> +    install: true,
> +)
> +
> +pkg = import('pkgconfig')
> +pkg.generate(libtraceevent,
> +    subdirs: 'traceevent',
> +    filebase: meson.project_name(),
> +    name: meson.project_name(),
> +    version: meson.project_version(),
> +    description: 'Manage trace event',
> +    url: 'https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/',
> +)
> +
> +libtraceevent_dep = declare_dependency(
> +    include_directories: ['.'],
> +    link_with: libtraceevent,
> +)
> diff --git a/utest/meson.build b/utest/meson.build
> new file mode 100644
> index 000000000000..e6ad5b50e9be
> --- /dev/null
> +++ b/utest/meson.build
> @@ -0,0 +1,14 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +source = [
> +    'trace-utest.c',
> +    'traceevent-utest.c',
> +]
> +
> +e = executable(
> +   'trace-utest',
> +   source,
> +   include_directories: [incdir],
> +   dependencies: [libtraceevent_dep, cunit_dep])
> +
> +test('trace-utest', e)

