Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbeIQWnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 18:43:40 -0400
Date: Mon, 17 Sep 2018 13:15:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel-shark-qt: Add "-O2" compiler flag
Message-ID: <20180917131522.0c9f6d5e@gandalf.local.home>
In-Reply-To: <20180917142942.7975-1-y.karadz@gmail.com>
References: <20180917142942.7975-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 17 Sep 2018 17:29:41 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> "-O2" compiler option is added to both C and C++ compiler flags.

Can you add -g as well. I know that somewhat contradicts the -O2 flag,
but it is also useful for debugging (even with optimization).

We can also add a debug option to not compile with -O2, but that can be
dealt with later.

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/CMakeLists.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
> index 0187eb4..7769604 100644
> --- a/kernel-shark-qt/CMakeLists.txt
> +++ b/kernel-shark-qt/CMakeLists.txt
> @@ -23,8 +23,8 @@ find_package(GLUT)
>  set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>  set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>  
> -set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread")
> -set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread")
> +set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -O2 -pthread")
> +set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -O2 -std=c++11 -pthread")
>  
>  include_directories(${KS_DIR}/src/
>                      ${KS_DIR}/build/src/
