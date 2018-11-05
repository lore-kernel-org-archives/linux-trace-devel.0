Return-Path: <SRS0=tXMv=NQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbeKEXzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Nov 2018 18:55:42 -0500
Date: Mon, 5 Nov 2018 09:35:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tools/lib/traceevent: Add support for man pages
 with multiple names
Message-ID: <20181105093540.2c875465@gandalf.local.home>
In-Reply-To: <20181102145714.25885-3-tstoyanov@vmware.com>
References: <20181102145714.25885-1-tstoyanov@vmware.com>
        <20181102145714.25885-3-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 2 Nov 2018 14:57:28 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch adds support for man pages with multiple names, used to combine the description of several APIs into one page.

The only comment I have for this patch is that the change log needs to
be no more than 76 characters in width (with the exception of showing
crash dumps and other "cut and paste" text).

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../traceevent/Documentation/asciidoc.conf    | 35 +++++++++++++++++--
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/traceevent/Documentation/asciidoc.conf
> index 1b03c63fb73a..07595717f06e 100644
> --- a/tools/lib/traceevent/Documentation/asciidoc.conf
> +++ b/tools/lib/traceevent/Documentation/asciidoc.conf
> @@ -74,12 +74,41 @@ template::[header-declarations]
>  <refmeta>
>  <refentrytitle>{mantitle}</refentrytitle>
>  <manvolnum>{manvolnum}</manvolnum>
> -<refmiscinfo class="source">trace-cmd</refmiscinfo>
> +<refmiscinfo class="source">libtraceevent</refmiscinfo>
>  <refmiscinfo class="version">{libtraceevent_version}</refmiscinfo>
> -<refmiscinfo class="manual">trace-cmd Manual</refmiscinfo>
> +<refmiscinfo class="manual">libtraceevent Manual</refmiscinfo>
>  </refmeta>
>  <refnamediv>
> -  <refname>{manname}</refname>
> +  <refname>{manname1}</refname>
> +  <refname>{manname2}</refname>
> +  <refname>{manname3}</refname>
> +  <refname>{manname4}</refname>
> +  <refname>{manname5}</refname>
> +  <refname>{manname6}</refname>
> +  <refname>{manname7}</refname>
> +  <refname>{manname8}</refname>
> +  <refname>{manname9}</refname>
> +  <refname>{manname10}</refname>
> +  <refname>{manname11}</refname>
> +  <refname>{manname12}</refname>
> +  <refname>{manname13}</refname>
> +  <refname>{manname14}</refname>
> +  <refname>{manname15}</refname>
> +  <refname>{manname16}</refname>
> +  <refname>{manname17}</refname>
> +  <refname>{manname18}</refname>
> +  <refname>{manname19}</refname>
> +  <refname>{manname20}</refname>
> +  <refname>{manname21}</refname>
> +  <refname>{manname22}</refname>
> +  <refname>{manname23}</refname>
> +  <refname>{manname24}</refname>
> +  <refname>{manname25}</refname>
> +  <refname>{manname26}</refname>
> +  <refname>{manname27}</refname>
> +  <refname>{manname28}</refname>
> +  <refname>{manname29}</refname>
> +  <refname>{manname30}</refname>
>    <refpurpose>{manpurpose}</refpurpose>
>  </refnamediv>
>  endif::backend-docbook[]
