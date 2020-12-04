Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3516C1B087
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 23:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9960622D57
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 23:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgLDXb4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbgLDXb4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 18:31:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71EFA22CA0;
        Fri,  4 Dec 2020 23:31:29 +0000 (UTC)
Date:   Fri, 4 Dec 2020 18:31:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark: Add support for drawing text
Message-ID: <20201204183127.186a7f87@gandalf.local.home>
In-Reply-To: <20201120095031.271735-2-y.karadz@gmail.com>
References: <20201120095031.271735-1-y.karadz@gmail.com>
        <20201120095031.271735-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Nov 2020 11:50:28 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> OpenGL doesn't provide support for text rendering. Here we first
> re-enable the compilation of the OpenGL wrapper and add the capability
> of printing text to the OpenGL scene by using the single-file public
> domain library "stb_truetype":
> https://github.com/nothings/stb/blob/master/stb_truetype.h
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  CMakeLists.txt                   |    6 +-
>  Documentation/doxygen/dox_config |    1 +
>  src/CMakeLists.txt               |    4 +-
>  src/libkshark-plot.c             |  244 +-
>  src/libkshark-plot.h             |   57 +
>  src/stb_truetype.h               | 5011 ++++++++++++++++++++++++++++++
>  6 files changed, 5312 insertions(+), 11 deletions(-)
>  create mode 100644 src/stb_truetype.h
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index ccca95c1..3d179778 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -26,9 +26,9 @@ include(${KS_DIR}/build/FindJSONC.cmake)
>  
>  find_package(Doxygen)
>  
> -# set(OpenGL_GL_PREFERENCE LEGACY)
> -# find_package(OpenGL)
> -# find_package(GLUT)
> +set(OpenGL_GL_PREFERENCE LEGACY)
> +find_package(OpenGL)
> +find_package(GLUT)
>  
>  # find_package(Qt5Widgets 5.7.1)
>  # find_package(Qt5Network)
> diff --git a/Documentation/doxygen/dox_config b/Documentation/doxygen/dox_config
> index 89b92842..0bbeb3f0 100644
> --- a/Documentation/doxygen/dox_config
> +++ b/Documentation/doxygen/dox_config
> @@ -14,3 +14,4 @@ SORT_MEMBER_DOCS       = NO
>  STRICT_PROTO_MATCHING  = YES
>  DOT_MULTI_TARGETS      = YES
>  PROJECT_LOGO           = ../../icons/KS_logo_stacked.svg
> +EXCLUDE                = ../../src/stb_truetype.h
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index ae5de54d..3a07d824 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -22,8 +22,8 @@ install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
>  if (OPENGL_FOUND AND GLUT_FOUND)
>  
>      message(STATUS "libkshark-plot")
> -    add_library(kshark-plot  SHARED  libkshark-plot.c
> -                                     KsPlotTools.cpp)
> +    add_library(kshark-plot  SHARED  libkshark-plot.c)
> +#                                      KsPlotTools.cpp)
>  
>      target_link_libraries(kshark-plot  kshark
>                                         ${GLUT_LIBRARY}
> diff --git a/src/libkshark-plot.c b/src/libkshark-plot.c
> index 17d3b903..06483334 100644
> --- a/src/libkshark-plot.c
> +++ b/src/libkshark-plot.c
> @@ -1,13 +1,22 @@
>  /* SPDX-License-Identifier: LGPL-2.1 */
>  
>  /*
> - * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>   */
>  
> - /**
> -  *  @file    libkshark-plot.c
> -  *  @brief   Basic tools for OpenGL plotting.
> -  */
> +/**
> + *  @file    libkshark-plot.c
> + *  @brief   Basic tools for OpenGL plotting.
> + */
> +
> +// C
> +#ifndef _GNU_SOURCE
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
> +
> +#include <string.h>
> +#include <stdio.h>
>  
>  // OpenGL
>  #include <GL/freeglut.h>
> @@ -16,6 +25,17 @@
>  // KernelShark
>  #include "libkshark-plot.h"
>  
> +/*
> + * STB TrueType (single-file public domain library)
> + * https://github.com/nothings/stb
> + */
> +/** Generate implementation. */
> +#define STB_TRUETYPE_IMPLEMENTATION
> +
> +/** Make the implementation private. */
> +#define STBTT_STATIC
> +#include "stb_truetype.h"
> +
>  /**
>   * @brief Create an empty scene for drawing.
>   *
> @@ -66,7 +86,7 @@ void ksplot_init_opengl(int dpr)
>  	glEnable(GL_POLYGON_SMOOTH);
>  	glLineWidth(1.5 * dpr);
>  	glPointSize(2.5 * dpr);
> -	glClearColor(1, 1, 1, 1);
> +	glClearColor(1, 1, 1, 1); // White
>  }
>  
>  /**
> @@ -210,3 +230,215 @@ void ksplot_draw_polygon_contour(const struct ksplot_point *points,
>  			 col,
>  			 size);
>  }
> +
> +/**
> + * @brief Find a TrueType font file.
> + *
> + * @param font_family: The family name of the font.
> + * @param font_name: The name of the font file without the extention.
> + *
> + * @returns A string containing the absolute path to the TrueType font file
> + *	    on success, or NULL on failure. The user is responsible for freeing
> + *	    the string.
> + */
> +char *ksplot_find_font_file(const char *font_family, const char *font_name)
> +{
> +	char buffer[1024], *end;
> +	char *cmd = NULL;
> +	int ret;
> +	FILE *f;
> +
> +	ret = asprintf(&cmd, "fc-list \'%s\' |grep %s.ttf", font_family,
> +							    font_name);

This is sorta a hack, but for now we can keep it and improve it later, as
it is wrapped in this function.

Perhaps add a comment /* FIXME: Do this a bit more properly */


> +	if (ret <= 0)
> +		goto fail;
> +
> +	f = popen(cmd, "r");
> +	free(cmd);
> +	if (f == NULL)
> +		goto fail;
> +
> +	end = fgets(buffer, sizeof(buffer), f);
> +	pclose(f);
> +	if (!end)
> +		goto fail;
> +
> +	end = strchr(buffer, ':');
> +	if (!end)
> +		goto fail;
> +
> +	return strndup(buffer, end - buffer);
> +
> + fail:
> +	fprintf(stderr, "Failed to find font file.\n" );
> +	return NULL;
> +}
> +
> +/** The size of the bitmap matrix used to load the font. */
> +#define KS_FONT_BITMAP_SIZE 1024
> +
> +/**
> + * @brief Initialize a font.
> + *
> + * @param font: Output location for the font descriptor.
> + * @param size: The size of the font.
> + * @param file: Input location for the truetype font file.
> + */
> +bool ksplot_init_font(struct ksplot_font *font, float size, const char *file)
> +{
> +	unsigned char bitmap[KS_FONT_BITMAP_SIZE * KS_FONT_BITMAP_SIZE];
> +	int ascent, descent, line_gap, lsb;
> +	ssize_t buff_size, ret;
> +	unsigned char *buffer;
> +	stbtt_fontinfo info;
> +	FILE *font_file;
> +	float scale;
> +
> +	font_file = fopen(file, "rb");
> +	if (!font_file) {
> +		fprintf(stderr, "Failed to open font file!\n");
> +		return false;
> +	}
> +
> +	/* Get the size of the file. */
> +	fseek(font_file, 0, SEEK_END);
> +	buff_size = ftell(font_file);

I would use stat(2) to find the file size.

> +	fseek(font_file, 0, SEEK_SET);
> +
> +	buffer = malloc(buff_size);
> +	if (!buffer) {
> +		fprintf(stderr, "Failed to allocat memory for font!\n");
> +		goto close_file;
> +	}
> +
> +	ret = fread(buffer, buff_size, 1, font_file);
> +	fclose(font_file);
> +
> +	if (ret == 0) {
> +		fprintf(stderr, "Failed to read from font file!\n");
> +		goto free_buffer;
> +	}
> +
> +	if (!stbtt_InitFont(&info, buffer, 0)) {
> +		fprintf(stderr, "Failed to init font!\n");
> +		goto free_buffer;
> +	}
> +
> +	/* Get the font's metrics. */
> +	scale = stbtt_ScaleForMappingEmToPixels(&info, size);
> +	stbtt_GetFontVMetrics(&info, &ascent, &descent, &line_gap);
> +	if (line_gap == 0)
> +		line_gap = - descent;
> +	/*
> +	 * Calculate the dimensions of the font. Note that the descent has
> +	 * a negative value.
> +	 */
> +	font->height = (- descent + ascent + line_gap) * scale;
> +	font->base = (- descent + line_gap / 2) * scale;
> +	font->size = size;
> +
> +	/*
> +	 * The width of the 'z' character will be considered as an average
> +	 * character width.
> +	 */
> +	stbtt_GetCodepointHMetrics(&info, 'z', &font->char_width, &lsb);
> +	font->char_width *= scale;
> +
> +	ret = stbtt_BakeFontBitmap(buffer,
> +				   0,
> +				   size,
> +				   bitmap,
> +				   KS_FONT_BITMAP_SIZE,
> +				   KS_FONT_BITMAP_SIZE,
> +				   KS_SPACE_CHAR,
> +				   KS_N_CHAR,
> +				   font->cdata);
> +
> +	if (ret <= 0) {
> +		fprintf(stderr, "Failed to bake font bitmap!\n");
> +		goto free_buffer;
> +	}
> +
> +	free(buffer);
> +
> +	glGenTextures(1, &font->texture_id);
> +	glBindTexture(GL_TEXTURE_2D, font->texture_id);
> +
> +	glTexImage2D(GL_TEXTURE_2D,
> +		     0,
> +		     GL_ALPHA,
> +		     KS_FONT_BITMAP_SIZE,
> +		     KS_FONT_BITMAP_SIZE,
> +		     0,
> +		     GL_ALPHA,
> +		     GL_UNSIGNED_BYTE,
> +		     bitmap);
> +
> +	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
> +	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
> +	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
> +	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
> +

I don't really understand any of the above, so I'm assuming you know what
it is doing ;-)

> +	return true;
> +
> + close_file:
> +	fclose(font_file);
> +
> + free_buffer:
> +	free(buffer);
> +	return false;
> +}
> +
> +/**
> + * @brief Print(draw) a text.
> + *
> + * @param font: Intput location for the font descriptor.
> + * @param col: The color of the polygon.
> + * @param x: Horizontal coordinate of the beginning of the text.
> + * @param y: Verticalal coordinate of the beginning of the text.
> + * @param text: The text to be drawn.
> + */
> +void ksplot_print_text(const struct ksplot_font *font,
> +		       const struct ksplot_color *col,
> +		       float x, float y,
> +		       const char *text)
> +{
> +	glEnable(GL_TEXTURE_2D);
> +
> +	/* Set the color of the text. */
> +	if (col)
> +		glColor3ub(col->red, col->green, col->blue);
> +	else
> +		glColor3ub(0, 0, 0); // Black
> +
> +	glBindTexture(GL_TEXTURE_2D, font->texture_id);
> +	glBegin(GL_QUADS);
> +	for (; *text; ++text) {
> +		if (*text < KS_SPACE_CHAR && *text > KS_TILDA_CHAR)
> +			continue;
> +
> +		stbtt_aligned_quad quad;
> +		stbtt_GetBakedQuad(font->cdata,
> +				   KS_FONT_BITMAP_SIZE,
> +				   KS_FONT_BITMAP_SIZE,
> +				   *text - KS_SPACE_CHAR,
> +				   &x, &y,
> +				   &quad,
> +				   1);
> +
> +		glTexCoord2f(quad.s0, quad.t1);
> +		glVertex2f(quad.x0, quad.y1);
> +
> +		glTexCoord2f(quad.s1, quad.t1);
> +		glVertex2f(quad.x1, quad.y1);
> +
> +		glTexCoord2f(quad.s1, quad.t0);
> +		glVertex2f(quad.x1, quad.y0);
> +
> +		glTexCoord2f(quad.s0, quad.t0);
> +		glVertex2f(quad.x0, quad.y0);

How is the x and y moved to the next location?

> +	}
> +
> +	glEnd();
> +	glDisable(GL_TEXTURE_2D);
> +}
> diff --git a/src/libkshark-plot.h b/src/libkshark-plot.h
> index 9a4dbc02..0edf5d50 100644
> --- a/src/libkshark-plot.h
> +++ b/src/libkshark-plot.h
> @@ -12,6 +12,15 @@
>  #ifndef _LIB_KSHARK_PLOT_H
>  #define _LIB_KSHARK_PLOT_H
>  
> +// C
> +#include <stdbool.h>
> +
> +/*
> + * STB TrueType (single-file public domain library)
> + * https://github.com/nothings/stb
> + */
> +#include "stb_truetype.h"
> +
>  #ifdef __cplusplus
>  extern "C" {
>  #endif
> @@ -62,6 +71,54 @@ void ksplot_draw_polygon_contour(const struct ksplot_point *points,
>  				 const struct ksplot_color *col,
>  				 float size);
>  
> +/** The index of the "Space" character. */
> +#define KS_SPACE_CHAR 32
> +
> +/** The index of the "Tilda" character. */
> +#define KS_TILDA_CHAR 126
> +
> +/** Total number of characters supported for drawing. */
> +#define KS_N_CHAR (KS_TILDA_CHAR - KS_SPACE_CHAR + 1)
> +
> +/** Structure defining a font. */
> +struct ksplot_font {
> +	/** Identifier of the font's texture. */
> +	GLuint texture_id;
> +
> +	/** Font's texture baking data. */
> +	stbtt_bakedchar cdata[KS_N_CHAR];
> +
> +	/** The height of a text line. */
> +	int height;
> +
> +	/** The vertical position of the font's baseline. */
> +	int base;
> +
> +	/** The size of the font. */
> +	int size;
> +
> +	/**
> +	 * The width of the 'z' character. To be use as an average character
> +	 * width.
> +	 */
> +	int char_width;
> +};
> +
> +/** Check if the texture of the font is loaded. */
> +static inline bool ksplot_font_is_loaded(struct ksplot_font *f)
> +{
> +	return f->texture_id > 1;
> +}
> +
> +char *ksplot_find_font_file(const char *font_family, const char *font_name);
> +
> +bool ksplot_init_font(struct ksplot_font *font, float size, const char *file);
> +
> +void ksplot_print_text(const struct ksplot_font *font,
> +		       const struct ksplot_color *col,
> +		       float x, float y,
> +		       const char *text);
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/src/stb_truetype.h b/src/stb_truetype.h
> new file mode 100644
> index 00000000..62595a15
> --- /dev/null
> +++ b/src/stb_truetype.h

I'm assuming the rest is what you took from public domain?

> @@ -0,0 +1,5011 @@
> +// stb_truetype.h - v1.24 - public domain
> +// authored from 2009-2020 by Sean Barrett / RAD Game Tools
> +//
> +// =======================================================================
> +//
> +//    NO SECURITY GUARANTEE -- DO NOT USE THIS ON UNTRUSTED FONT FILES
> +//
> +// This library does no range checking of the offsets found in the file,
> +// meaning an attacker can use it to read arbitrary memory.
> +//
> +// =======================================================================
> +//
> +//   This library processes TrueType files:
> +//        parse files
> +//        extract glyph metrics
> +//        extract glyph shapes
> +//        render glyphs to one-channel bitmaps with antialiasing (box filter)
> +//        render glyphs to one-channel SDF bitmaps (signed-distance field/function)
> +//
> +//   Todo:
> +//        non-MS cmaps
> +//        crashproof on bad data
> +//        hinting? (no longer patented)
> +//        cleartype-style AA?
> +//        optimize: use simple memory allocator for intermediates
> +//        optimize: build edge-list directly from curves
> +//        optimize: rasterize directly from curves?
> +//
> +// ADDITIONAL CONTRIBUTORS
> +//
> +//   Mikko Mononen: compound shape support, more cmap formats
> +//   Tor Andersson: kerning, subpixel rendering
> +//   Dougall Johnson: OpenType / Type 2 font handling
> +//   Daniel Ribeiro Maciel: basic GPOS-based kerning

[..]
