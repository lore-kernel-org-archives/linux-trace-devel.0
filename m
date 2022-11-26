Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF72C4321E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Nov 2022 02:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKZCTy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiKZCTx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 21:19:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7357B1A3AA
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 18:19:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D125CCE2F73
        for <linux-trace-devel@vger.kernel.org>; Sat, 26 Nov 2022 02:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60BCC433C1;
        Sat, 26 Nov 2022 02:19:48 +0000 (UTC)
Date:   Fri, 25 Nov 2022 21:19:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC v2] libtracefs: Add initial support for meson
Message-ID: <20221125211946.4e066aed@rorschach.local.home>
In-Reply-To: <20220707142744.8801-1-dwagner@suse.de>
References: <20220707142744.8801-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jul 2022 16:27:44 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> Add support for building the project with meson. It's not complete
> yet, for example building and installing the documentation is missing.
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
> 
> I am using an alias for 'ninja -C .build' which is called 'ni'. This
> makes way more convenient to use.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> v2:
>  - updated commit message
>  - dropped the include path patch, the pkg-config
>    from libtraceevent is including them
> 
> v1:
>  - initial version
> 
>  include/meson.build |  9 ++++++++
>  meson.build         | 32 +++++++++++++++++++++++++++
>  src/meson.build     | 53 +++++++++++++++++++++++++++++++++++++++++++++
>  utest/meson.build   | 14 ++++++++++++
>  4 files changed, 108 insertions(+)
>  create mode 100644 include/meson.build
>  create mode 100644 meson.build
>  create mode 100644 src/meson.build
>  create mode 100644 utest/meson.build
> 
> diff --git a/include/meson.build b/include/meson.build
> new file mode 100644
> index 000000000000..1bbfe8afb280
> --- /dev/null
> +++ b/include/meson.build
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +headers = [
> +   'tracefs.h',
> +]
> +
> +foreach h : headers
> +	install_headers(h, subdir : 'libtracefs')
> +endforeach
> diff --git a/meson.build b/meson.build
> new file mode 100644
> index 000000000000..2138d2f149f1
> --- /dev/null
> +++ b/meson.build
> @@ -0,0 +1,32 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +project(
> +    'libtracefs', ['c'],
> +    meson_version: '>= 0.47.0',
> +    license: 'LGPL-2.1',
> +    version: '1.4.0',
> +    default_options: [
> +      'c_std=gnu99',
> +      'buildtype=release',
> +      'prefix=/usr',
> +      'warning_level=1',
> +    ]
> +)
> +
> +library_version = meson.project_version()
> +
> +libtraceevent_dep = dependency('libtraceevent', required: true)

Can the dependency also include a version? It will be needed here and
in trace-cmd.

-- Steve


> +cunit_dep = dependency('cunit', required : false)
> +
> +add_project_arguments(
> +    [
> +      '-D_GNU_SOURCE',
> +    ],
> +    language : 'c',
> +)
> +
> +incdir = include_directories(['include'])
> +
> +subdir('src')
> +subdir('include')
> +subdir('utest')
> diff --git a/src/meson.build b/src/meson.build
> new file mode 100644
> index 000000000000..36d3be359fae
> --- /dev/null
> +++ b/src/meson.build
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +sources= [
> +   'tracefs-dynevents.c',
> +   'tracefs-eprobes.c',
> +   'tracefs-events.c',
> +   'tracefs-filter.c',
> +   'tracefs-hist.c',
> +   'tracefs-instance.c',
> +   'tracefs-kprobes.c',
> +   'tracefs-marker.c',
> +   'tracefs-sqlhist.c',
> +   'tracefs-tools.c',
> +   'tracefs-uprobes.c',
> +   'tracefs-utils.c',
> +]
> +
> +flex = find_program('flex', required: true)
> +bison = find_program('bison', required: true)
> +
> +lgen = generator(flex,
> +output : '@PLAINNAME@.yy.c',
> +arguments : ['-o', '@OUTPUT@', '@INPUT@'])
> +
> +pgen = generator(bison,
> +output : ['@BASENAME@.tab.c', '@BASENAME@.tab.h'],
> +arguments : ['@INPUT@', '--defines=@OUTPUT1@', '--output=@OUTPUT0@'])
> +
> +lfiles = lgen.process('sqlhist.l')
> +pfiles = pgen.process('sqlhist.y')
> +
> +libtracefs = library(
> +    'tracefs',
> +    sources, lfiles, pfiles,
> +    version: library_version,
> +    dependencies: [libtraceevent_dep],
> +    include_directories: [incdir],
> +    install: true,
> +)
> +
> +pkg = import('pkgconfig')
> +pkg.generate(libtracefs,
> +    filebase: meson.project_name(),
> +    name: meson.project_name(),
> +    version: meson.project_version(),
> +    description: 'Manage trace fs',
> +    url: 'https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/',
> +)
> +
> +libtracefs_dep = declare_dependency(
> +    include_directories: ['.'],
> +    link_with: libtracefs,
> +)
> diff --git a/utest/meson.build b/utest/meson.build
> new file mode 100644
> index 000000000000..07058afb5f9b
> --- /dev/null
> +++ b/utest/meson.build
> @@ -0,0 +1,14 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +
> +source = [
> +    'trace-utest.c',
> +    'tracefs-utest.c',
> +]
> +
> +e = executable(
> +   'trace-utest',
> +   source,
> +   include_directories: [incdir],
> +   dependencies: [libtracefs_dep, libtraceevent_dep, cunit_dep])
> +
> +test('trace-utest', e)

