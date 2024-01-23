Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AF75EE81
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017359; cv=none; b=L5Voi/pJn38tBjz+v46OejNaO6AVOrp4WWmZ2CE5wU7AXDW6GJTcl3/Bi9N5k7EfI6ruo2fWyqxtjrQjso5RMz+P2B3QfyH0lYh/xTmvCEaMVMt/sRWm+JkbgFLDBH2VRzxfxEJcWEnn34lZaWyMyOph8sh+dCwP6+93hqfGO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017359; c=relaxed/simple;
	bh=FiJS2gY0BjdjMvUELYGh39y/t8j1TJhYi1720rbn8y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d1oUdGTkvfYT3EJB253jypJkFKs1hIJ3k4RXQJ93Y1mMASDBVMCLm0LNS0CewHplyKEBXjhsYrodHD1LiZ6G/x0SfIu4PESHbaaRugzUGOzSd0RUDNwfvNEve/oZ7D0LjYJMmOyelEFXttZlpW9YIMYqleynt5tejrj2+TMiHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3D63113E;
	Tue, 23 Jan 2024 05:43:21 -0800 (PST)
Received: from e126645.home (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C50D3F762;
	Tue, 23 Jan 2024 05:42:35 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v3 2/5] trace-cmd split: Add functions to generate temp files
Date: Tue, 23 Jan 2024 14:42:12 +0100
Message-Id: <20240123134215.385415-3-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240123134215.385415-1-pierre.gondois@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare handling of multiple instances and storing them
in temporary files, add utility functions generating file names,
removing files, creating files:
- get_temp_file()
- delete_temp_file()
- put_temp_file()
- touch_file()

Also make use these functions.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 73 +++++++++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 15 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index d5b77ab7..58ea7c48 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -421,6 +421,55 @@ static int parse_cpu(struct tracecmd_input *handle,
 	return 0;
 }
 
+static char *get_temp_file(const char *output_file, const char *name, int cpu)
+{
+	const char *dot;
+	char *file = NULL;
+	char *output;
+	char *base;
+	char *dir;
+	int ret;
+
+	if (name)
+		dot = ".";
+	else
+		dot = name = "";
+
+	output = strdup(output_file);
+	if (!output)
+		die("Failed to duplicate %s", output_file);
+
+	/* Extract basename() first, as dirname() truncates output */
+	base = basename(output);
+	dir = dirname(output);
+
+	ret = asprintf(&file, "%s/.tmp.%s.%s%s%d", dir, base, name, dot, cpu);
+	if (ret < 0)
+		die("Failed to allocate file for %s %s %s %d", dir, base, name, cpu);
+	free(output);
+	return file;
+}
+
+static void delete_temp_file(const char *name)
+{
+	unlink(name);
+}
+
+static void put_temp_file(char *file)
+{
+	free(file);
+}
+
+static void touch_file(const char *file)
+{
+	int fd;
+
+	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0)
+		die("could not create file %s\n", file);
+	close(fd);
+}
+
 static unsigned long long parse_file(struct tracecmd_input *handle,
 				     const char *output_file,
 				     unsigned long long start,
@@ -434,19 +483,11 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 	struct cpu_data *cpu_data;
 	struct tep_record *record;
 	char **cpu_list;
-	char *output;
-	char *base;
 	char *file;
-	char *dir;
 	int cpus;
 	int cpu;
 	int fd;
 
-	output = strdup(output_file);
-	/* Extract basename() first, as dirname() truncates output */
-	base = basename(output);
-	dir = dirname(output);
-
 	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
 
 	cpus = tracecmd_cpus(handle);
@@ -455,11 +496,9 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 		die("Failed to allocate cpu_data for %d cpus", cpus);
 
 	for (cpu = 0; cpu < cpus; cpu++) {
-		int ret;
+		file = get_temp_file(output_file, NULL, cpu);
+		touch_file(file);
 
-		ret = asprintf(&file, "%s/.tmp.%s.%d", dir, base, cpu);
-		if (ret < 0)
-			die("Failed to allocate file for %s %s %d", dir, base, cpu);
 		fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
 		cpu_data[cpu].cpu = cpu;
 		cpu_data[cpu].fd = fd;
@@ -498,12 +537,16 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				current = record->ts + 1;
 			tracecmd_free_record(record);
 		}
-		unlink(cpu_data[cpu].file);
-		free(cpu_data[cpu].file);
+	}
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		close(cpu_data[cpu].fd);
+		delete_temp_file(cpu_data[cpu].file);
+		put_temp_file(cpu_data[cpu].file);
 	}
 	free(cpu_data);
 	free(cpu_list);
-	free(output);
+
 	tracecmd_output_close(ohandle);
 
 	return current;
-- 
2.25.1

