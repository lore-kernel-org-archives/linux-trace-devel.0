Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E9C107BB
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7E4C433D9;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000DtA-3H5G;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/23] libtracefs: Add tracefs_instance_file_write_number()
Date: Thu, 28 Dec 2023 15:35:32 -0500
Message-ID: <20231228203714.53294-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the helper function to write a number into a tracefs file. As tracefs
files require writing strings and not binary numbers, this is a helper
function that does the conversion to string followed by a
tracefs_instance_file_write() on that string.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracefs-instances-file-manip.txt       |  9 +++++-
 Documentation/libtracefs.txt                  |  1 +
 include/tracefs.h                             |  2 ++
 src/tracefs-instance.c                        | 21 +++++++++++++
 utest/tracefs-utest.c                         | 30 ++++++++++++++++++-
 5 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-file-manip.txt b/Documentation/libtracefs-instances-file-manip.txt
index 8c04240523d3..bb1b36e36c3e 100644
--- a/Documentation/libtracefs-instances-file-manip.txt
+++ b/Documentation/libtracefs-instances-file-manip.txt
@@ -5,7 +5,7 @@ NAME
 ----
 
 tracefs_instance_file_open,
-tracefs_instance_file_write, tracefs_instance_file_append, tracefs_instance_file_clear,
+tracefs_instance_file_write, tracefs_instance_file_write_number, tracefs_instance_file_append, tracefs_instance_file_clear,
 tracefs_instance_file_read, tracefs_instance_file_read_number - Work with files in tracing instances.
 
 SYNOPSIS
@@ -16,6 +16,7 @@ SYNOPSIS
 
 int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+int *tracefs_instance_file_write_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, size_t _val_);
 int *tracefs_instance_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
 int *tracefs_instance_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
@@ -38,6 +39,10 @@ The *tracefs_instance_file_write()* function writes a string _str_ in a _file_ f
 the given _instance_, without the terminating NULL character. When opening the file, this function
 tries to truncates the size of the file to zero, which clears all previously existing settings.
 
+The *tracefs_instance_file_write_number()* function converts _val_ into a string
+and then writes it to the given file. This is a helper function that does the number
+conversion to string and then calls *tracefs_instance_file_write()*.
+
 The *tracefs_instance_file_append()* function writes a string _str_ in a _file_ from
 the given _instance_, without the terminating NULL character.  This function is similar to
 *tracefs_instance_file_write()*, but the existing content of the is not cleared. Thus the
@@ -61,6 +66,8 @@ closed with *close*(3). In case of an error, -1 is returned.
 The *tracefs_instance_file_write()* function returns the number of written bytes,
 or -1 in case of an error.
 
+The *tracefs_instance_file_write_number()* function returns 0 on success and -1 on error.
+
 The *tracefs_instance_file_append()* function returns the number of written bytes,
 or -1 in case of an error.
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 850118302ab2..11ff576e826c 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -33,6 +33,7 @@ Trace instances:
 	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+	int *tracefs_instance_file_write_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, size_t _val_);
 	int *tracefs_instance_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
 	int *tracefs_instance_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 25429a30c028..0971d54dd7c7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -36,6 +36,8 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
+int tracefs_instance_file_write_number(struct tracefs_instance *instance,
+				       const char *file, size_t val);
 int tracefs_instance_file_append(struct tracefs_instance *instance,
 				 const char *file, const char *str);
 int tracefs_instance_file_clear(struct tracefs_instance *instance,
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 2efcc75dfd98..b019836333a3 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -493,6 +493,27 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 	return instance_file_write(instance, file, str, O_WRONLY | O_TRUNC);
 }
 
+/**
+ * tracefs_instance_file_write_number - Write integer from a trace file.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @res: The integer to write to @file
+ *
+ * Returns 0 if the write succeeds, -1 on error.
+ */
+int tracefs_instance_file_write_number(struct tracefs_instance *instance,
+				       const char *file, size_t val)
+{
+	char buf[64];
+	int ret;
+
+	snprintf(buf, 64, "%zd\n", val);
+
+	ret = tracefs_instance_file_write(instance, file, buf);
+
+	return ret > 1 ? 0 : -1;
+}
+
 /**
  * tracefs_instance_file_append - Append to a trace file of specific instance.
  * @instance: ftrace instance, can be NULL for the top instance.
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 492e5c05551f..98cfd322b171 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -488,7 +488,7 @@ static int setup_trace_cpu(struct tracefs_instance *instance, struct test_cpu_da
 	if (!data->buf)
 		goto fail;
 
-	data->kbuf = kbuffer_alloc(sizeof(long) == 8, !tep_is_bigendian());
+	data->kbuf = tep_kbuffer(data->tep);
 	CU_TEST(data->kbuf != NULL);
 	if (!data->kbuf)
 		goto fail;
@@ -2127,6 +2127,7 @@ static void test_instance_file_fd(struct tracefs_instance *instance)
 	const char *name = get_rand_str();
 	const char *tdir = tracefs_instance_get_trace_dir(instance);
 	long long res = -1;
+	long long res2;
 	char rd[2];
 	int fd;
 
@@ -2146,7 +2147,34 @@ static void test_instance_file_fd(struct tracefs_instance *instance)
 	CU_TEST(read(fd, &rd, 1) == 1);
 	rd[1] = 0;
 	CU_TEST(res == atoi(rd));
+	close(fd);
+
+	/* Inverse tracing_on and test changing it with write_number */
+	res ^= 1;
 
+	CU_TEST(tracefs_instance_file_write_number(instance, TRACE_ON, (size_t)res) == 0);
+
+	CU_TEST(tracefs_instance_file_read_number(instance, TRACE_ON, &res2) == 0);
+	CU_TEST(res2 == res);
+	fd = tracefs_instance_file_open(instance, TRACE_ON, O_RDONLY);
+	CU_TEST(fd >= 0);
+	CU_TEST(read(fd, &rd, 1) == 1);
+	rd[1] = 0;
+	CU_TEST(res2 == atoi(rd));
+	close(fd);
+
+	/* Put back the result of tracing_on */
+	res ^= 1;
+
+	CU_TEST(tracefs_instance_file_write_number(instance, TRACE_ON, (size_t)res) == 0);
+
+	CU_TEST(tracefs_instance_file_read_number(instance, TRACE_ON, &res2) == 0);
+	CU_TEST(res2 == res);
+	fd = tracefs_instance_file_open(instance, TRACE_ON, O_RDONLY);
+	CU_TEST(fd >= 0);
+	CU_TEST(read(fd, &rd, 1) == 1);
+	rd[1] = 0;
+	CU_TEST(res2 == atoi(rd));
 	close(fd);
 }
 
-- 
2.42.0

